Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34953 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbcFKWzl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 18:55:41 -0400
Received: by mail-lf0-f66.google.com with SMTP id w130so5444086lfd.2
        for <linux-media@vger.kernel.org>; Sat, 11 Jun 2016 15:55:40 -0700 (PDT)
Date: Sun, 12 Jun 2016 00:55:36 +0200
From: Henrik Austad <henrik@austad.us>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, alsa-devel@vger.kernel.org,
	netdev@vger.kernel.org, henrk@austad.us,
	Henrik Austad <haustad@cisco.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [very-RFC 4/8] Add TSN header for the driver
Message-ID: <20160611225536.GI10685@sisyphus.home.austad.us>
References: <1465683741-20390-1-git-send-email-henrik@austad.us>
 <1465683741-20390-5-git-send-email-henrik@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465683741-20390-5-git-send-email-henrik@austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clearing up netdev-typo
-H

On Sun, Jun 12, 2016 at 12:22:17AM +0200, Henrik Austad wrote:
> From: Henrik Austad <haustad@cisco.com>
> 
> This defines the general TSN headers for network packets, the
> shim-interface and the central 'tsn_list' structure.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Henrik Austad <haustad@cisco.com>
> ---
>  include/linux/tsn.h | 806 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 806 insertions(+)
>  create mode 100644 include/linux/tsn.h
> 
> diff --git a/include/linux/tsn.h b/include/linux/tsn.h
> new file mode 100644
> index 0000000..0e1f732b
> --- /dev/null
> +++ b/include/linux/tsn.h
> @@ -0,0 +1,806 @@
> +/*   TSN - Time Sensitive Networking
> + *
> + *   Copyright (C) 2016- Henrik Austad <haustad@cisco.com>
> + *
> + *   This program is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU General Public License as published by
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *   GNU General Public License for more details.
> + */
> +#ifndef _TSN_H
> +#define _TSN_H
> +#include <linux/list.h>
> +#include <linux/configfs.h>
> +#include <linux/hrtimer.h>
> +
> +/* The naming here can be a bit confusing as we call it TSN but naming
> + * suggests 'AVB'. Reason: IEE 1722 was written before the working group
> + * was renamed to Time Sensitive Networking.
> + *
> + * To be precise. TSN describes the protocol for shipping data, AVB is a
> + * medialayer which you can build on top of TSN.
> + *
> + * For this reason the frames are given avb-names whereas the functions
> + * use tsn_-naming.
> + */
> +
> +/* 7 bit value 0x00 - 0x7F */
> +enum avtp_subtype {
> +	AVTP_61883_IIDC = 0,
> +	AVTP_MMA = 0x1,
> +	AVTP_MAAP = 0x7e,
> +	AVTP_EXPERIMENTAL = 0x7f,
> +};
> +
> +/*		NOTE NOTE NOTE !!
> + * The headers below use bitfields extensively and verifications
> + * are needed when using little-endian vs big-endian systems.
> + */
> +
> +/* Common part of avtph header
> + *
> + * AVB Transport Protocol Common Header
> + *
> + * Defined in 1722-2011 Sec. 5.2
> + */
> +struct avtp_ch {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	/* use avtp_subtype enum.
> +	 */
> +	u8 subtype:7;
> +
> +	/* Controlframe: 1
> +	 * Dataframe   : 0
> +	 */
> +	u8 cd:1;
> +
> +	/* Type specific data, part 1 */
> +	u8 tsd_1:4;
> +
> +	/* In current version of AVB, only 0 is valid, all other values
> +	 * are reserved for future versions.
> +	 */
> +	u8 version:3;
> +
> +	/* Valid StreamID in frame
> +	 *
> +	 * ControlData not related to a specific stream should clear
> +	 * this (and have stream_id = 0), _all_ other values should set
> +	 * this to 1.
> +	 */
> +	u8 sv:1;
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	u8 cd:1;
> +	u8 subtype:7;
> +	u8 sv:1;
> +	u8 version:3;
> +	u8 tsd_1:4;
> +#else
> +#error "Unknown Endianness, cannot determine bitfield ordering"
> +#endif
> +	/* Type specific data (adjacent to tsd_1, but split due to bitfield) */
> +	u16 tsd_2;
> +	u64 stream_id;
> +
> +	/*
> +	 * payload by subtype
> +	 */
> +	u8 pbs[0];
> +} __packed;
> +
> +/* AVTPDU Common Control header format
> + * IEEE 1722#5.3
> + */
> +struct avtpc_header {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	u8 subtype:7;
> +	u8 cd:1;
> +	u8 control_data:4;
> +	u8 version:3;
> +	u8 sv:1;
> +	u16 control_data_length:11;
> +	u16 status:5;
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	u8 cd:1;
> +	u8 subtype:7;
> +	u8 sv:1;
> +	u8 version:3;
> +	u8 control_data:4;
> +	u16 status:5;
> +	u16 control_data_length:11;
> +#else
> +#error "Unknown Endianness, cannot determine bitfield ordering"
> +#endif
> +	u64 stream_id;
> +} __packed;
> +
> +/* AVTP common stream data AVTPDU header format
> + * IEEE 1722#5.4
> + */
> +struct avtpdu_header {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	u8 subtype:7;
> +	u8 cd:1;
> +
> +	/* avtp_timestamp valid */
> +	u8 tv: 1;
> +
> +	/* gateway_info valid */
> +	u8 gv:1;
> +
> +	/* reserved */
> +	u8 r:1;
> +
> +	/*
> +	 * Media clock Restart toggle
> +	 */
> +	u8 mr:1;
> +
> +	u8 version:3;
> +
> +	/* StreamID valid */
> +	u8 sv:1;
> +	u8 seqnr;
> +
> +	/* Timestamp uncertain */
> +	u8 tu:1;
> +	u8 r2:7;
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	u8 cd:1;
> +	u8 subtype:7;
> +
> +	u8 sv:1;
> +	u8 version:3;
> +	u8 mr:1;
> +	u8 r:1;
> +	u8 gv:1;
> +	u8 tv: 1;
> +
> +	u8 seqnr;
> +	u8 r2:7;
> +	u8 tu:1;
> +#else
> +#error "Unknown Endianness, cannot determine bitfield ordering"
> +#endif
> +
> +	u64 stream_id;
> +
> +	u32 avtp_timestamp;
> +	u32 gateway_info;
> +
> +	/* Stream Data Length */
> +	u16 sd_len;
> +
> +	/* Protocol specific header, derived from avtp_subtype */
> +	u16 psh;
> +
> +	/* Stream Payload Data 0 to n octets
> +	 * n so that total size < MTU
> +	 */
> +	u8 data[0];
> +} __packed;
> +
> +
> +/**
> + * struct tsn_list - The top level container of TSN
> + *
> + * This is what tsn_configfs refers to as 'tier-0'
> + *
> + * @head List of TSN cards
> + * @lock lock protecting global entries
> + * @tsn_subsys Ref to ConfigFS subsystem
> + *
> + * @running: hrtimer is running driving data out
> + * @tsn_timer: hrtimer container
> + * @num_avail Number of available TSN NICs exposed through ConfigFS
> + */
> +struct tsn_list {
> +	struct list_head head;
> +	struct mutex lock;
> +	struct configfs_subsystem tsn_subsys;
> +
> +	/*
> +	 * TSN-timer is running. Not to be confused with the per-link
> +	 * disabled flag which indicates if a remote client, like aplay,
> +	 * is pushing data to it.
> +	 */
> +	atomic_t running;
> +	struct hrtimer tsn_timer;
> +	unsigned int period_ns;
> +
> +
> +	size_t num_avail;
> +};
> +
> +/**
> + * struct tsn_nic
> + *
> + * Individual TSN-capable NICs, or 'tier-1' struct
> + *
> + * @list linked list of all TSN NICs
> + * @group configfs group
> + * @dev corresponding net_device
> + * @dma_size : size of the DMA buffer
> + * @dma_handle: housekeeping DMA-stuff
> + * @dma_mem : pointer to memory region we're using for DMAing to the NIC
> + * @name Name of NIC (same as name in dev), TO BE REMOVED
> + * @txq Size of Tx-queue. TO BE REMOVED
> + * @rx_registered flag indicating if a handler is registered for the nic
> + * @capable: if the NIC is capable for proper TSN traffic or if it must
> + *	     be emulated in software.
> + *
> + */
> +struct tsn_nic {
> +	struct list_head list;
> +	struct config_group group;
> +	struct net_device *dev;
> +	struct tsn_list *tsn_list;
> +
> +	size_t dma_size;
> +	dma_addr_t dma_handle;
> +	void *dma_mem;
> +
> +	char *name;
> +	int txq;
> +	u8 rx_registered:1;
> +	u8 capable:1;
> +	u8 reserved:6;
> +};
> +
> +struct tsn_shim_ops;
> +/**
> + * tsn_link - Structure describing a single TSN link
> + *
> + */
> +struct tsn_link {
> +	/*
> +	 * Lock for protecting the buffer
> +	 */
> +	spinlock_t lock;
> +
> +	struct config_group group;
> +	struct tsn_nic *nic;
> +	struct hlist_node node;
> +
> +	/* The link itself is active, and the tsn_core will treat it as
> +	 * an active participant and feed data from it to the
> +	 * network. This places some restrictions on which attributes
> +	 * can be changed.
> +	 *
> +	 * 1: active
> +	 * 0: inactive
> +	 */
> +	atomic_t active;
> +
> +	u64 timer_period_ns;
> +
> +	/* Pointer to media-specific data.
> +	 * e.g. struct avb_chip
> +	 */
> +	void *media_chip;
> +
> +	u64 stream_id;
> +
> +	/*
> +	 * The max required size for a _single_ TSN frame.
> +	 *
> +	 * To be used instead of channels and sample_freq.
> +	 */
> +	u16 max_payload_size;
> +	u16 shim_header_size;
> +
> +	/*
> +	 * Size of buffer (in bytes) to use when handling data to/from
> +	 * NIC.
> +	 *
> +	 * Smaller size will result in client being called more often
> +	 * but also provides lower latencies.
> +	 */
> +	size_t buffer_size;
> +	size_t used_buffer_size;
> +
> +	/*
> +	 * Used when frames are constructed and shipped to the network
> +	 * layer. If this is true, 0-frames will be sent insted of data
> +	 * from the buffer.
> +	 */
> +	atomic_t buffer_active;
> +
> +	/*
> +	 * ringbuffer for incoming or outging traffic
> +	 * +-----------------------------------+
> +	 * |                  ##########       |
> +	 * +-----------------------------------+
> +	 * ^                  ^         ^      ^
> +	 * buffer           tail      head    end
> +	 *
> +	 * Buffer: start of memory area
> +	 * tail: first byte of data in buffer
> +	 * head: first unused slot in which to store new data
> +	 *
> +	 * head,tail is used to represent the position of 'live data' in
> +	 * the buffer.
> +	 */
> +	void *buffer;
> +	void *head;
> +	void *tail;
> +	void *end;
> +
> +	/* Number of bytes to run refill/drain callbacks */
> +	size_t low_water_mark;
> +	size_t high_water_mark;
> +
> +
> +	/*
> +	 * callback ops.
> +	 */
> +	struct tsn_shim_ops *ops;
> +
> +	/*
> +	 * EndStation Type
> +	 *
> +	 * Either Talker or Listener
> +	 *
> +	 * 1: We are *Talker*, i.e. producing data to send
> +	 * 0: We are *Listener*, i.e. we receive data from another ES.
> +	 *
> +	 * This is for a single link, so even though an end-station can
> +	 * be both Talker *and* Listener, a link can only be one.
> +	 */
> +	u8 estype_talker;
> +
> +	/*
> +	 * Link will use buffer managed by the shim. For this to work,
> +	 * the shim must:
> +	 *
> +	 * - call tsn_use_external_buffer(link, size);
> +	 * - provide tsn_shim_buffer_swap(link) in tsn_shim_ops
> +	 */
> +	u8 external_buffer;
> +
> +	u8 last_seqnr;
> +
> +	/*
> +	 * Class can be either A or B
> +	 *
> +	 * ClassA: every 125us
> +	 * ClassB: every 250us
> +	 *
> +	 * This will also affect how large each frame will be.
> +	 */
> +	u8 class_a:1;
> +
> +	/*
> +	 * Any AVTP data stream must set the 802.1Q vlan id and priority
> +	 * Code point. This should be obtained from MSRP, default values
> +	 * are:
> +	 *
> +	 * pvid: SR_PVID 2
> +	 * pcp: Class A: 3
> +	 *	Class B: 2
> +	 *
> +	 * See IEEE 802.1Q-2011, Sec 35.2.2.9.3 and table 6-6 in 6.6.2
> +	 * for details
> +	 */
> +	u8 pcp_a:3;
> +	u8 pcp_b:3;
> +	u16 vlan_id:12;
> +
> +	u8 remote_mac[6];
> +};
> +
> +/**
> + * tsn_link_on - make link active
> + *
> + * This cause most of the attributes to be treated read-only since we
> + * will have to re-negotiate with the network if most of these
> + * parameters change.
> + *
> + * Note: this means that the link will be handled by the rx-handler or
> + * the timer callback, but until the link_buffer is set active (via
> + * tsn_lb_on()), actual data is not moved.
> + *
> + * @link: link being set to active
> + */
> +static inline void tsn_link_on(struct tsn_link *link)
> +{
> +	if (link)
> +		atomic_set(&link->active, 1);
> +}
> +
> +/**
> + * tsn_link_off - make link inactive
> + *
> + * The link will now be ignored by timer callback or the
> + * rx-handler. Attributes can be mostly freely changed (we assume that
> + * userspace sets values that are negotiated properly).
> + *
> + * @link: link to deactivate
> + */
> +static inline void tsn_link_off(struct tsn_link *link)
> +{
> +	if (link)
> +		atomic_set(&link->active, 0);
> +}
> +
> +/**
> + * tsn_link_is_on - query link to see if it is active
> + *
> + * Mostly used by tsn_configfs to respect the "read-only" once link is
> + * configured and made active.
> + *
> + * @link active link
> + * @returns 1 if active/on, 0 otherwise
> + */
> +static inline int tsn_link_is_on(struct tsn_link *link)
> +{
> +	if (link)
> +		return atomic_read(&link->active);
> +	return 0;
> +}
> +
> +/**
> + * tsn_set_buffer_size - adjust buffersize to match a shim
> + *
> + * This will not allocate (or deallcoate) memory, just adjust how much
> + * of the buffer allocated in tsn_prepare_link is being used. tsn_
> + * expects tsn_clear_buffer_size() to be invoked when stream is closed.
> + */
> +int tsn_set_buffer_size(struct tsn_link *link, size_t bsize);
> +int tsn_clear_buffer_size(struct tsn_link *link);
> +
> +/**
> + * tsn_buffer_write write data into the buffer from shim
> + *
> + * This is called from the shim-driver when more data is available and
> + * data needs to be pushed out to the network.
> + *
> + * NOTE: This is used when TSN handles the databuffer. This will not be
> + *	 needed for "shim-hosted" buffers.
> + *
> + * _If_ this function is called when the link is inactive, it will
> + * _enable_ the link (i.e. link will mark the buffer as 'active'). Do
> + * not copy data into the buffer unless you are ready to start sending
> + * frames!
> + *
> + * @link active link
> + * @src	the buffer to copy data from
> + * @bytes bytes to copy
> + * @return bytes copied from link->buffer or negative error
> + */
> +int tsn_buffer_write(struct tsn_link *link, void *src, size_t bytes);
> +
> +
> +/**
> + * tsn_buffer_read - read data from link->buffer and give to shim
> + *
> + * When we act as a listener, this is what the shim (should|will) call
> + * to grab data. It typically grabs much more data than the _net
> + * equivalent. It also do not trigger a refill-event the same way
> + * buffer_read_net does.
> + *
> + * @param link current link that holds the buffer
> + * @param buffer the buffer to copy into, must be at least of size bytes
> + * @param bytes number of bytes.
> + *
> + * Note that this routine does NOT CARE about channels, samplesize etc,
> + * it is a _pure_ copy that handles ringbuffer wraps etc.
> + *
> + * This function have side-effects as it will update internal tsn_link
> + * values.
> + *
> + * @return Bytes copied into link->buffer, negative value upon error.
> + */
> +int tsn_buffer_read(struct tsn_link *link, void *buffer, size_t bytes);
> +
> +/**
> + * tsn_lb_enable - TSN Link Buffer Enable
> + *
> + * Mark the link as "buffer-enabled" which will let the core start
> + * shifting data in/out of the buffer instead of ignoring incoming
> + * frames or sending "nullframes".
> + *
> + * This is for the network-end of the tsn-buffer, i.e.
> + * - when enabled frames *from* the network will be inserted into the buffer,
> + * - or frames going *out* will include data from the buffer instead of sending
> + *   null-frames.
> + *
> + * When disabled, data will be zero'd, e.g Tx will send NULL-frames and
> + * Rx will silently drop the frames.
> + *
> + * @link: active link
> + */
> +static inline void tsn_lb_enable(struct tsn_link *link)
> +{
> +	if (link)
> +		atomic_set(&link->buffer_active, 1);
> +}
> +
> +/**
> + * tsn_lb_disable - stop using the buffer for the net-side of TSN
> + *
> + * When we close a stream, we do not necessarily tear down the link, and
> + * we need to handle the data in some way.
> + */
> +static inline void tsn_lb_disable(struct tsn_link *link)
> +{
> +	if (link)
> +		atomic_set(&link->buffer_active, 0);
> +}
> +
> +/**
> + * tsn_lb() - query if we have disabled pushing of data to/from link-buffer
> + *
> + * @param struct tsn_link *link - active link
> + * @returns 1 if link is enabled
> + */
> +static inline int tsn_lb(struct tsn_link *link)
> +{
> +	if (link)
> +		return atomic_read(&link->buffer_active);
> +
> +	/* if link is NULL; buffer not active */
> +	return 0;
> +}
> +
> +
> +/**
> + * Shim ops - what tsn_core use when calling back into the shim. All ops
> + * must be reentrant.
> + */
> +#define SHIM_NAME_SIZE 32
> +struct tsn_shim_ops {
> +
> +	/* internal linked list used by tsn_core to keep track of all
> +	 * shims.
> +	 */
> +	struct list_head head;
> +
> +	/**
> +	 * name - a unique name identifying this shim
> +	 *
> +	 * This is what userspace use to indicate to core what SHIM a
> +	 * particular link will use. If the name is already present,
> +	 * core will reject this name.
> +	 */
> +	char shim_name[SHIM_NAME_SIZE];
> +
> +	/**
> +	 * probe - callback when a new link of this type is instantiated.
> +	 *
> +	 * When a new link is brought online, this is called once the
> +	 * essential parts of tsn_core has finiesh. Once probe_cb has
> +	 * finisehd, the shim _must_ be ready to accept data to/from
> +	 * tsn_core. On the other hand, due to the final steps of setup,
> +	 * it cannot expect to be called into action immediately after
> +	 * probe has finished.
> +	 *
> +	 * In other words, shim must be ready, but core doesn't have to
> +	 *
> +	 * @param : a particular link to pass along to the probe-function.
> +	 */
> +	int (*probe)(struct tsn_link *link);
> +
> +	/**
> +	 * buffer_swap - set a new buffer for the link. [OPTIONAL]
> +	 *
> +	 * Used when external buffering is enabled.
> +	 *
> +	 * When called, a new buffer must be returned WITHOUT blocking
> +	 * as this will be called from interrupt context.
> +	 *
> +	 * The buffer returned from the shim must be at least the size
> +	 * of used_buffer_size.
> +	 *
> +	 * @param current link
> +	 * @param old_buffer the buffer that are no longer needed
> +	 * @param used number of bytes in buffer that has been filled with data.
> +	 * @return new buffer to use
> +	 */
> +	void * (*buffer_swap)(struct tsn_link *link, void *old_buffer,
> +			      size_t used);
> +
> +	/**
> +	 * buffer_refill - signal shim that more data is required
> +	 * @link Active link
> +	 *
> +	 * This function should not do anything that can preempt the
> +	 * task (kmalloc, sleeping lock) or invoke actions that can take
> +	 * a long time to complete.
> +	 *
> +	 * This will be called from tsn_buffer_read_net() when available
> +	 * data in the buffer drops below low_water_mark. It will be
> +	 * called with the link-lock *held*
> +	 */
> +	size_t (*buffer_refill)(struct tsn_link *link);
> +
> +	/**
> +	 * buffer_drain - shim need to copy data from buffer
> +	 *
> +	 * This will be called from tsn_buffer_write_net() when data in
> +	 * the buffer exceeds high_water_mark.
> +	 *
> +	 * The expected behavior is for the shim to then fill data into
> +	 * the buffer via tsn_buffer_write()
> +	 */
> +	size_t (*buffer_drain)(struct tsn_link *link);
> +
> +	/**
> +	 * media_close - shut down media controller properly
> +	 *
> +	 * when the link is closed/removed for some reason
> +	 * external to the media controller (ALSA soundcard, v4l2 driver
> +	 * etc), we call this to clean up.
> +	 *
> +	 * Normal operation is stopped before media_close is called, but
> +	 * all references should be valid. TSN core expects media_close
> +	 * to handle any local cleanup, once returned, any references in
> +	 * stale tsn_links cannot be trusted.
> +	 *
> +	 * @link: current link where data is stored
> +	 * @returns: 0 upon success, negative on error.
> +	 */
> +	int (*media_close)(struct tsn_link *link);
> +
> +	/**
> +	 * hdr_size - ask shim how large the header is
> +	 *
> +	 * Needed when reserving space in skb for transmitting data.
> +	 *
> +	 * @link: current link where data is stored
> +	 * @return: size of header for this shim
> +	 */
> +	size_t (*hdr_size)(struct tsn_link *link);
> +
> +	/**
> +	 * copy_size - ask client how much from the buffer to include in
> +	 *	       the next frame.
> +	 *
> +	 *	       This is for *outgoing* frames, incoming frames
> +	 *	       have 'sd_len' set in the header.
> +	 *
> +	 *	       Note: copy_size should not return a size larger
> +	 *		     than link->max_payload_size
> +	 */
> +	size_t (*copy_size)(struct tsn_link *link);
> +
> +	/**
> +	 * validate_header - let the shim validate subtype-header
> +	 *
> +	 * Both psh and data may (or may not) contain headers that need
> +	 * validating. This is the responsibility of the shim to
> +	 * validate, and ops->valdiate_header() will be called before
> +	 * any data is copied from the incoming frame and into the
> +	 * buffer.
> +	 *
> +	 * Important: tsn_core expects validate_header to _not_ alter
> +	 * the contents of the frame, and ideally, validate_header could
> +	 * be called multiple times and give the same result.
> +	 *
> +	 * @param: active link owning the new data
> +	 * @param: start of data-unit header
> +	 *
> +	 * This function will be called from interrupt-context and MUST
> +	 * NOT take any locks.
> +	 */
> +	int (*validate_header)(struct tsn_link *link,
> +			       struct avtpdu_header *header);
> +
> +	/**
> +	 * assemble_header - add shim-specific headers
> +	 *
> +	 * This adds the headers required by the current shim after the
> +	 * generic 1722-header.
> +	 *
> +	 * @param: active link
> +	 * @param: start of data-unit header
> +	 * @param: size of data to send in this frame
> +	 * @return void
> +	 */
> +	void (*assemble_header)(struct tsn_link *link,
> +				struct avtpdu_header *header, size_t bytes);
> +
> +	/**
> +	 * get_payload_data - get a pointer to where the data is stored
> +	 *
> +	 * core will use the pointer (or drop it if NULL is returned)
> +	 * and copy header->sd_len bytes of *consecutive* data from the
> +	 * target memory and into the buffer memory.
> +	 *
> +	 * This is called with relevant locks held, from interrupt context.
> +	 *
> +	 * @param link active link
> +	 * @param header header of frame, which contains data
> +	 * @returns pointer to memory to copy from
> +	 */
> +	void * (*get_payload_data)(struct tsn_link *link,
> +				   struct avtpdu_header *header);
> +};
> +/**
> + * tsn_shim_register_ops - register shim-callbacks for a given shim
> + *
> + * @param shim_ops - callbacks. The ops-struct should be kept intact for
> + *		     as long as the driver is running.
> + *
> + *
> + */
> +int tsn_shim_register_ops(struct tsn_shim_ops *shim_ops);
> +
> +/**
> + * tsn_shim_deregister_ops - remove callback for module
> + *
> + * Completely remove shim_ops. This will close any links currently using
> + * this shim. Note: the links will be closed, but _not_ removed.
> + *
> + * @param shim_ops ops associated with this shim
> + */
> +void tsn_shim_deregister_ops(struct tsn_shim_ops *shim_ops);
> +
> +/**
> + * tsn_shim_get_active : return the name of the currently loaded shim
> + *
> + * @param current link
> + * @return name of shim (matches an entry from exported triggers)
> + */
> +char *tsn_shim_get_active(struct tsn_link *link);
> +
> +/**
> + * tsn_shim_find_by_name find shim_ops by name
> + *
> + * @param name of shim
> + * @return shim or NULL if not found/error.
> + */
> +struct tsn_shim_ops *tsn_shim_find_by_name(const char *name);
> +
> +/**
> + * tsn_shim_export_probe_triggers - export a list of registered shims
> + *
> + * @param page to write content into
> + * @returns length of data written to page
> + */
> +ssize_t tsn_shim_export_probe_triggers(char *page);
> +
> +/**
> + * tsn_get_framesize - get the size of the next TSN frame to send
> + *
> + * This will call into the shim to get the next chunk of data to
> + * read. Some sanitychecking is performed, i.e.
> + *
> + * 0 <= size <= max_payload_size
> + *
> + * @param struct tsn_link *link active link
> + * @returns size of frame in bytes or negative on error.
> + */
> +static inline size_t tsn_shim_get_framesize(struct tsn_link *link)
> +{
> +	size_t ret;
> +
> +	ret = link->ops->copy_size(link);
> +	if (ret <= link->max_payload_size)
> +		return ret;
> +	return link->max_payload_size;
> +}
> +
> +/**
> + * tsn_get_hdr_size - get the size of the shim-specific header size
> + *
> + * The shim will add it's own header to the frame.
> + */
> +static inline size_t tsn_shim_get_hdr_size(struct tsn_link *link)
> +{
> +	size_t ret;
> +
> +	if (!link || !link->ops->hdr_size)
> +		return -EINVAL;
> +	ret = link->ops->hdr_size(link);
> +	if (ret > link->max_payload_size)
> +		return -EINVAL;
> +	return ret;
> +}
> +
> +#endif	/* _TSN_H */
> -- 
> 2.7.4
> 

-- 
Henrik Austad
