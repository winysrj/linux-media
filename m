Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45207
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbcFQI4E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 04:56:04 -0400
Date: Fri, 17 Jun 2016 05:55:52 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Hans Verkuil <hansverk@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv16 07/13] cec.txt: add CEC framework documentation
Message-ID: <20160617055552.19ee1297@recife.lan>
In-Reply-To: <5763A51D.7040009@xs4all.nl>
References: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
	<1461937948-22936-8-git-send-email-hverkuil@xs4all.nl>
	<20160616171244.3ef5a7b4@recife.lan>
	<5763A51D.7040009@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Jun 2016 09:22:05 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/16/2016 10:12 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 29 Apr 2016 15:52:22 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hansverk@cisco.com>
> >>
> >> Document the new HDMI CEC framework.  
> > 
> > As we'll be moving documentation to Sphinx/Rst, it would be good if
> > you could make it work fine with sphinx, as this will likely be needed
> > for Kernel 4.9. Right now it most works, although several warnings are
> > produced:   
> 
> Would it be a problem if this conversion is done later in a separate patch?
> 
> I'm all for it, but I don't have the time at the moment to do this.

No problem. This can be done later.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > /devel/v4l/patchwork/tmp/cec.txt:40: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:40: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:40: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:40: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:40: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:42: WARNING: Definition list ends without a blank line; unexpected unindent.
> > /devel/v4l/patchwork/tmp/cec.txt:42: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:67: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:71: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:92: ERROR: Unexpected indentation.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:87: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:92: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:93: WARNING: Block quote ends without a blank line; unexpected unindent.
> > /devel/v4l/patchwork/tmp/cec.txt:93: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:93: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:95: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:97: WARNING: Definition list ends without a blank line; unexpected unindent.
> > /devel/v4l/patchwork/tmp/cec.txt:105: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:105: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:118: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:118: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:130: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:130: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:144: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:144: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:144: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:161: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:161: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:161: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:173: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:194: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:203: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:203: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:214: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:217: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:217: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:217: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:217: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:219: WARNING: Definition list ends without a blank line; unexpected unindent.
> > /devel/v4l/patchwork/tmp/cec.txt:224: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:224: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:224: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:238: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:238: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:243: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:258: WARNING: Inline emphasis start-string without end-string.
> > /devel/v4l/patchwork/tmp/cec.txt:258: WARNING: Inline emphasis start-string without end-string.
> > 
> >   
> >>
> >> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> >> [k.debski@samsung.com: add DocBook documentation by Hans Verkuil, with
> >> Signed-off-by: Kamil Debski <kamil@wypas.org>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  Documentation/cec.txt | 267 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 267 insertions(+)
> >>  create mode 100644 Documentation/cec.txt
> >>
> >> diff --git a/Documentation/cec.txt b/Documentation/cec.txt
> >> new file mode 100644
> >> index 0000000..75155fe
> >> --- /dev/null
> >> +++ b/Documentation/cec.txt
> >> @@ -0,0 +1,267 @@
> >> +CEC Kernel Support
> >> +==================
> >> +
> >> +The CEC framework provides a unified kernel interface for use with HDMI CEC
> >> +hardware. It is designed to handle a multiple types of hardware (receivers,
> >> +transmitters, USB dongles). The framework also gives the option to decide
> >> +what to do in the kernel driver and what should be handled by userspace
> >> +applications. In addition it integrates the remote control passthrough
> >> +feature into the kernel's remote control framework.
> >> +
> >> +
> >> +The CEC Protocol
> >> +----------------
> >> +
> >> +The CEC protocol enables consumer electronic devices to communicate with each
> >> +other through the HDMI connection. The protocol uses logical addresses in the
> >> +communication. The logical address is strictly connected with the functionality
> >> +provided by the device. The TV acting as the communication hub is always
> >> +assigned address 0. The physical address is determined by the physical
> >> +connection between devices.
> >> +
> >> +The CEC framework described here is up to date with the CEC 2.0 specification.
> >> +It is documented in the HDMI 1.4 specification with the new 2.0 bits documented
> >> +in the HDMI 2.0 specification. But for most of the features the freely available
> >> +HDMI 1.3a specification is sufficient:
> >> +
> >> +http://www.microprocessor.org/HDMISpecification13a.pdf
> >> +
> >> +
> >> +The Kernel Interface
> >> +====================
> >> +
> >> +CEC Adapter
> >> +-----------
> >> +
> >> +The struct cec_adapter represents the CEC adapter hardware. It is created by
> >> +calling cec_allocate_adapter() and deleted by calling cec_delete_adapter():
> >> +
> >> +struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
> >> +	       void *priv, const char *name, u32 caps, u8 available_las,
> >> +	       struct device *parent);
> >> +void cec_delete_adapter(struct cec_adapter *adap);
> >> +
> >> +To create an adapter you need to pass the following information:
> >> +
> >> +ops: adapter operations which are called by the CEC framework and that you
> >> +have to implement.
> >> +
> >> +priv: will be stored in adap->priv and can be used by the adapter ops.
> >> +
> >> +name: the name of the CEC adapter. Note: this name will be copied.
> >> +
> >> +caps: capabilities of the CEC adapter. These capabilities determine the
> >> +	capabilities of the hardware and which parts are to be handled
> >> +	by userspace and which parts are handled by kernelspace. The
> >> +	capabilities are returned by CEC_ADAP_G_CAPS.
> >> +
> >> +available_las: the number of simultaneous logical addresses that this
> >> +	adapter can handle. Must be 1 <= available_las <= CEC_MAX_LOG_ADDRS.
> >> +
> >> +parent: the parent device.
> >> +
> >> +
> >> +To register the /dev/cecX device node and the remote control device (if
> >> +CEC_CAP_RC is set) you call:
> >> +
> >> +int cec_register_adapter(struct cec_adapter *adap);
> >> +
> >> +To unregister the devices call:
> >> +
> >> +void cec_unregister_adapter(struct cec_adapter *adap);
> >> +
> >> +Note: if cec_register_adapter() fails, then call cec_delete_adapter() to
> >> +clean up. But if cec_register_adapter() succeeded, then only call
> >> +cec_unregister_adapter() to clean up, never cec_delete_adapter(). The
> >> +unregister function will delete the adapter automatically once the last user
> >> +of that /dev/cecX device has closed its file handle.
> >> +
> >> +
> >> +Implementing the Low-Level CEC Adapter
> >> +--------------------------------------
> >> +
> >> +The following low-level adapter operations have to be implemented in
> >> +your driver:
> >> +
> >> +struct cec_adap_ops {
> >> +	/* Low-level callbacks */
> >> +	int (*adap_enable)(struct cec_adapter *adap, bool enable);
> >> +	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
> >> +	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
> >> +	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
> >> +			     u32 signal_free_time, struct cec_msg *msg);
> >> +	void (*adap_log_status)(struct cec_adapter *adap);
> >> +
> >> +	/* High-level callbacks */
> >> +	...
> >> +};
> >> +
> >> +The three low-level ops deal with various aspects of controlling the CEC adapter
> >> +hardware:
> >> +
> >> +
> >> +To enable/disable the hardware:
> >> +
> >> +	int (*adap_enable)(struct cec_adapter *adap, bool enable);
> >> +
> >> +This callback enables or disables the CEC hardware. Enabling the CEC hardware
> >> +means powering it up in a state where no logical addresses are claimed. This
> >> +op assumes that the physical address (adap->phys_addr) is valid when enable is
> >> +true and will not change while the CEC adapter remains enabled. The initial
> >> +state of the CEC adapter after calling cec_allocate_adapter() is disabled.
> >> +
> >> +Note that adap_enable must return 0 if enable is false.
> >> +
> >> +
> >> +To enable/disable the 'monitor all' mode:
> >> +
> >> +	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
> >> +
> >> +If enabled, then the adapter should be put in a mode to also monitor messages
> >> +that not for us. Not all hardware supports this and this function is only
> >> +called if the CEC_CAP_MONITOR_ALL capability is set. This callback is optional
> >> +(some hardware may always be in 'monitor all' mode).
> >> +
> >> +Note that adap_monitor_all_enable must return 0 if enable is false.
> >> +
> >> +
> >> +To program a new logical address:
> >> +
> >> +	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
> >> +
> >> +If logical_addr == CEC_LOG_ADDR_INVALID then all programmed logical addresses
> >> +are to be erased. Otherwise the given logical address should be programmed.
> >> +If the maximum number of available logical addresses is exceeded, then it
> >> +should return -ENXIO. Once a logical address is programmed the CEC hardware
> >> +can receive directed messages to that address.
> >> +
> >> +Note that adap_log_addr must return 0 if logical_addr is CEC_LOG_ADDR_INVALID.
> >> +
> >> +
> >> +To transmit a new message:
> >> +
> >> +	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
> >> +			     u32 signal_free_time, struct cec_msg *msg);
> >> +
> >> +This transmits a new message. The attempts argument is the suggested number of
> >> +attempts for the transmit.
> >> +
> >> +The signal_free_time is the number of data bit periods that the adapter should
> >> +wait when the line is free before attempting to send a message. This value
> >> +depends on whether this transmit is a retry, a message from a new initiator or
> >> +a new message for the same initiator. Most hardware will handle this
> >> +automatically, but in some cases this information is needed.
> >> +
> >> +The CEC_FREE_TIME_TO_USEC macro can be used to convert signal_free_time to
> >> +microseconds (one data bit period is 2.4 ms).
> >> +
> >> +
> >> +To log the current CEC hardware status:
> >> +
> >> +	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
> >> +
> >> +This optional callback can be used to show the status of the CEC hardware.
> >> +The status is available through debugfs: cat /sys/kernel/debug/cec/cecX/status
> >> +
> >> +
> >> +Your adapter driver will also have to react to events (typically interrupt
> >> +driven) by calling into the framework in the following situations:
> >> +
> >> +When a transmit finished (successfully or otherwise):
> >> +
> >> +void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
> >> +		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
> >> +
> >> +The status can be one of:
> >> +
> >> +CEC_TX_STATUS_OK: the transmit was successful.
> >> +CEC_TX_STATUS_ARB_LOST: arbitration was lost: another CEC initiator
> >> +took control of the CEC line and you lost the arbitration.
> >> +CEC_TX_STATUS_NACK: the message was nacked (for a directed message) or
> >> +acked (for a broadcast message). A retransmission is needed.
> >> +CEC_TX_STATUS_LOW_DRIVE: low drive was detected on the CEC bus. This
> >> +indicates that a follower detected an error on the bus and requested a
> >> +retransmission.
> >> +CEC_TX_STATUS_ERROR: some unspecified error occurred: this can be one of
> >> +the previous two if the hardware cannot differentiate or something else
> >> +entirely.
> >> +CEC_TX_STATUS_MAX_RETRIES: could not transmit the message after
> >> +trying multiple times. Should only be set by the driver if it has hardware
> >> +support for retrying messages. If set, then the framework assumes that it
> >> +doesn't have to make another attempt to transmit the message since the
> >> +hardware did that already.
> >> +
> >> +The *_cnt arguments are the number of error conditions that were seen.
> >> +This may be 0 if no information is available. Drivers that do not support
> >> +hardware retry can just set the counter corresponding to the transmit error
> >> +to 1, if the hardware does support retry then either set these counters to
> >> +0 if the hardware provides no feedback of which errors occurred and how many
> >> +times, or fill in the correct values as reported by the hardware.
> >> +
> >> +When a CEC message was received:
> >> +
> >> +void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
> >> +
> >> +Speaks for itself.
> >> +
> >> +Implementing the High-Level CEC Adapter
> >> +---------------------------------------
> >> +
> >> +The low-level operations drive the hardware, the high-level operations are
> >> +CEC protocol driven. The following high-level callbacks are available:
> >> +
> >> +struct cec_adap_ops {
> >> +	/* Low-level callbacks */
> >> +	...
> >> +
> >> +	/* High-level CEC message callback */
> >> +	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
> >> +};
> >> +
> >> +The received() callback allows the driver to optionally handle a newly
> >> +received CEC message
> >> +
> >> +	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
> >> +
> >> +If the driver wants to process a CEC message, then it can implement this
> >> +callback. If it doesn't want to handle this message, then it should return
> >> +-ENOMSG, otherwise the CEC framework assumes it processed this message and
> >> +it will not no anything with it.
> >> +
> >> +
> >> +CEC framework functions
> >> +-----------------------
> >> +
> >> +CEC Adapter drivers can call the following CEC framework functions:
> >> +
> >> +int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
> >> +		     bool block);
> >> +
> >> +Transmit a CEC message. If block is true, then wait until the message has been
> >> +transmitted, otherwise just queue it and return.
> >> +
> >> +void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block);
> >> +
> >> +Change the physical address. This function will set adap->phys_addr and
> >> +send an event if it has changed. If cec_s_log_addrs() has been called and
> >> +the physical address has become valid, then the CEC framework will start
> >> +claiming the logical addresses. If block is true, then this function won't
> >> +return until this process has finished.
> >> +
> >> +When the physical address is set to a valid value the CEC adapter will
> >> +be enabled (see the adap_enable op). When it is set to CEC_PHYS_ADDR_INVALID,
> >> +then the CEC adapter will be disabled. If you change a valid physical address
> >> +to another valid physical address, then this function will first set the
> >> +address to CEC_PHYS_ADDR_INVALID before enabling the new physical address.
> >> +
> >> +int cec_s_log_addrs(struct cec_adapter *adap,
> >> +		    struct cec_log_addrs *log_addrs, bool block);
> >> +
> >> +Claim the CEC logical addresses. Should never be called if CEC_CAP_LOG_ADDRS
> >> +is set. If block is true, then wait until the logical addresses have been
> >> +claimed, otherwise just queue it and return. To unconfigure all logical
> >> +addresses call this function with log_addrs set to NULL or with
> >> +log_addrs->num_log_addrs set to 0. The block argument is ignored when
> >> +unconfiguring. This function will just return if the physical address is
> >> +invalid. Once the physical address becomes valid, then the framework will
> >> +attempt to claim these logical addresses.  
> > 
> > 
> > 
> > Thanks,
> > Mauro
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   



Thanks,
Mauro
