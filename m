Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbbJJNgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 11/26] [media] DocBook: Move struct dmx_demux kABI doc to demux.h
Date: Sat, 10 Oct 2015 10:35:54 -0300
Message-Id: <95abfdb942a44e165c54a4e890a9b91a1eeb8621.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DocBook/media/dvb/kdapi.xml contains the description of
the kABI for DVB. The problem is that, by being maintained
on a separate file and not being updated for years, it got
outdated. So, for example, some callback parameters were
changed, but the DocBook were still using the old stuff.

As a first step to fix it, let's move the documentation of
struct dmx_demux into demux.h and fix the parameters used
there.

For now, don't document any other field nor touch the
descriptions that got moved, letting this job to other
patches. That makes easier to review the patch.

PS.: Please notice that an additional patch will be needed
in order to fix the return values (some uses non-existent
return codes) and to the functions and callbacks mentioned at
the descriptions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 44634e295699..8d5620aeaf36 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -239,6 +239,7 @@ X!Isound/sound_firmware.c
      </sect1>
      <sect1><title>Digital TV (DVB) devices</title>
 !Idrivers/media/dvb-core/dvb_ca_en50221.h
+!Idrivers/media/dvb-core/demux.h
 !Idrivers/media/dvb-core/dvb_frontend.h
 !Idrivers/media/dvb-core/dvb_math.h
 !Idrivers/media/dvb-core/dvb_ringbuffer.h
diff --git a/Documentation/DocBook/media/dvb/kdapi.xml b/Documentation/DocBook/media/dvb/kdapi.xml
index 68bcd33a82c3..6efc3ab7944e 100644
--- a/Documentation/DocBook/media/dvb/kdapi.xml
+++ b/Documentation/DocBook/media/dvb/kdapi.xml
@@ -214,62 +214,6 @@ should be kept identical) to the types in the demux device.
   &#x22C6; to the type &#x22C6; dmx_frontend_t
   &#x22C6;.
  &#x22C6;/
-
- #define DMX_FE_ENTRY(list) list_entry(list, dmx_frontend_t, connectivity_list)
-
- struct dmx_demux_s {
-	 /&#x22C6; The following char&#x22C6; fields point to NULL terminated strings &#x22C6;/
-	 char&#x22C6; id;                    /&#x22C6; Unique demux identifier &#x22C6;/
-	 char&#x22C6; vendor;                /&#x22C6; Name of the demux vendor &#x22C6;/
-	 char&#x22C6; model;                 /&#x22C6; Name of the demux model &#x22C6;/
-	 __u32 capabilities;          /&#x22C6; Bitfield of capability flags &#x22C6;/
-	 dmx_frontend_t&#x22C6; frontend;    /&#x22C6; Front-end connected to the demux &#x22C6;/
-	 struct list_head reg_list;   /&#x22C6; List of registered demuxes &#x22C6;/
-	 void&#x22C6; priv;                  /&#x22C6; Pointer to private data of the API client &#x22C6;/
-	 int users;                   /&#x22C6; Number of users &#x22C6;/
-	 int (&#x22C6;open) (struct dmx_demux_s&#x22C6; demux);
-	 int (&#x22C6;close) (struct dmx_demux_s&#x22C6; demux);
-	 int (&#x22C6;write) (struct dmx_demux_s&#x22C6; demux, const char&#x22C6; buf, size_t count);
-	 int (&#x22C6;allocate_ts_feed) (struct dmx_demux_s&#x22C6; demux,
-				  dmx_ts_feed_t&#x22C6;&#x22C6; feed,
-				  dmx_ts_cb callback);
-	 int (&#x22C6;release_ts_feed) (struct dmx_demux_s&#x22C6; demux,
-				 dmx_ts_feed_t&#x22C6; feed);
-	 int (&#x22C6;allocate_pes_feed) (struct dmx_demux_s&#x22C6; demux,
-				   dmx_pes_feed_t&#x22C6;&#x22C6; feed,
-				   dmx_pes_cb callback);
-	 int (&#x22C6;release_pes_feed) (struct dmx_demux_s&#x22C6; demux,
-				  dmx_pes_feed_t&#x22C6; feed);
-	 int (&#x22C6;allocate_section_feed) (struct dmx_demux_s&#x22C6; demux,
-				       dmx_section_feed_t&#x22C6;&#x22C6; feed,
-				       dmx_section_cb callback);
-	 int (&#x22C6;release_section_feed) (struct dmx_demux_s&#x22C6; demux,
-				      dmx_section_feed_t&#x22C6; feed);
-	 int (&#x22C6;descramble_mac_address) (struct dmx_demux_s&#x22C6; demux,
-					__u8&#x22C6; buffer1,
-					size_t buffer1_length,
-					__u8&#x22C6; buffer2,
-					size_t buffer2_length,
-					__u16 pid);
-	 int (&#x22C6;descramble_section_payload) (struct dmx_demux_s&#x22C6; demux,
-					    __u8&#x22C6; buffer1,
-					    size_t buffer1_length,
-					    __u8&#x22C6; buffer2, size_t buffer2_length,
-					    __u16 pid);
-	 int (&#x22C6;add_frontend) (struct dmx_demux_s&#x22C6; demux,
-			      dmx_frontend_t&#x22C6; frontend);
-	 int (&#x22C6;remove_frontend) (struct dmx_demux_s&#x22C6; demux,
-				 dmx_frontend_t&#x22C6; frontend);
-	 struct list_head&#x22C6; (&#x22C6;get_frontends) (struct dmx_demux_s&#x22C6; demux);
-	 int (&#x22C6;connect_frontend) (struct dmx_demux_s&#x22C6; demux,
-				  dmx_frontend_t&#x22C6; frontend);
-	 int (&#x22C6;disconnect_frontend) (struct dmx_demux_s&#x22C6; demux);
-
-
-	 /&#x22C6; added because js cannot keep track of these himself &#x22C6;/
-	 int (&#x22C6;get_pes_pids) (struct dmx_demux_s&#x22C6; demux, __u16 &#x22C6;pids);
- };
- typedef struct dmx_demux_s dmx_demux_t;
 </programlisting>
 
 </section>
@@ -487,985 +431,7 @@ interface from a bottom half context. Thus, if a demux API function is called fr
 device code, the function must not sleep.
 </para>
 
-
-<section id="kdapi_fopen">
-<title>open()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This function reserves the demux for use by the caller and, if necessary,
- initializes the demux. When the demux is no longer needed, the function close()
- should be called. It should be possible for multiple clients to access the demux
- at the same time. Thus, the function implementation should increment the
- demux usage count when open() is called and decrement it when close() is
- called.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int open ( demux_t&#x22C6; demux );</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>demux_t* demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EUSERS</para>
-</entry><entry
- align="char">
-<para>Maximum usage count reached.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
 </section>
-<section id="kdapi_fclose">
-<title>close()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This function reserves the demux for use by the caller and, if necessary,
- initializes the demux. When the demux is no longer needed, the function close()
- should be called. It should be possible for multiple clients to access the demux
- at the same time. Thus, the function implementation should increment the
- demux usage count when open() is called and decrement it when close() is
- called.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int close(demux_t&#x22C6; demux);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>demux_t* demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-ENODEV</para>
-</entry><entry
- align="char">
-<para>The demux was not in use.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section>
-<section id="kdapi_fwrite">
-<title>write()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This function provides the demux driver with a memory buffer containing TS
- packets. Instead of receiving TS packets from the DVB front-end, the demux
- driver software will read packets from memory. Any clients of this demux
- with active TS, PES or Section filters will receive filtered data via the Demux
- callback API (see 0). The function returns when all the data in the buffer has
- been consumed by the demux. Demux hardware typically cannot read TS from
- memory. If this is the case, memory-based filtering has to be implemented
- entirely in software.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int write(demux_t&#x22C6; demux, const char&#x22C6; buf, size_t
- count);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>demux_t* demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>const char* buf</para>
-</entry><entry
- align="char">
-<para>Pointer to the TS data in kernel-space memory.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>size_t length</para>
-</entry><entry
- align="char">
-<para>Length of the TS data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-ENOSYS</para>
-</entry><entry
- align="char">
-<para>The command is not implemented.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>allocate_ts_feed()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Allocates a new TS feed, which is used to filter the TS packets carrying a
- certain PID. The TS feed normally corresponds to a hardware PID filter on the
- demux chip.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int allocate_ts_feed(dmx_demux_t&#x22C6; demux,
- dmx_ts_feed_t&#x22C6;&#x22C6; feed, dmx_ts_cb callback);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>demux_t* demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_ts_feed_t**
- feed</para>
-</entry><entry
- align="char">
-<para>Pointer to the TS feed API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_ts_cb callback</para>
-</entry><entry
- align="char">
-<para>Pointer to the callback function for passing received TS
- packet</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EBUSY</para>
-</entry><entry
- align="char">
-<para>No more TS feeds available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-ENOSYS</para>
-</entry><entry
- align="char">
-<para>The command is not implemented.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>release_ts_feed()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Releases the resources allocated with allocate_ts_feed(). Any filtering in
- progress on the TS feed should be stopped before calling this function.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int release_ts_feed(dmx_demux_t&#x22C6; demux,
- dmx_ts_feed_t&#x22C6; feed);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>demux_t* demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_ts_feed_t* feed</para>
-</entry><entry
- align="char">
-<para>Pointer to the TS feed API and instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>allocate_section_feed()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Allocates a new section feed, i.e. a demux resource for filtering and receiving
- sections. On platforms with hardware support for section filtering, a section
- feed is directly mapped to the demux HW. On other platforms, TS packets are
- first PID filtered in hardware and a hardware section filter then emulated in
- software. The caller obtains an API pointer of type dmx_section_feed_t as an
- out parameter. Using this API the caller can set filtering parameters and start
- receiving sections.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int allocate_section_feed(dmx_demux_t&#x22C6; demux,
- dmx_section_feed_t &#x22C6;&#x22C6;feed, dmx_section_cb callback);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>demux_t *demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_section_feed_t
- **feed</para>
-</entry><entry
- align="char">
-<para>Pointer to the section feed API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_section_cb
- callback</para>
-</entry><entry
- align="char">
-<para>Pointer to the callback function for passing received
- sections.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EBUSY</para>
-</entry><entry
- align="char">
-<para>No more section feeds available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-ENOSYS</para>
-</entry><entry
- align="char">
-<para>The command is not implemented.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>release_section_feed()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Releases the resources allocated with allocate_section_feed(), including
- allocated filters. Any filtering in progress on the section feed should be stopped
- before calling this function.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int release_section_feed(dmx_demux_t&#x22C6; demux,
- dmx_section_feed_t &#x22C6;feed);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>demux_t *demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_section_feed_t
- *feed</para>
-</entry><entry
- align="char">
-<para>Pointer to the section feed API and instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>descramble_mac_address()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This function runs a descrambling algorithm on the destination MAC
- address field of a DVB Datagram Section, replacing the original address
- with its un-encrypted version. Otherwise, the description on the function
- descramble_section_payload() applies also to this function.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int descramble_mac_address(dmx_demux_t&#x22C6; demux, __u8
- &#x22C6;buffer1, size_t buffer1_length, __u8 &#x22C6;buffer2,
- size_t buffer2_length, __u16 pid);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>dmx_demux_t
- *demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>__u8 *buffer1</para>
-</entry><entry
- align="char">
-<para>Pointer to the first byte of the section.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>size_t buffer1_length</para>
-</entry><entry
- align="char">
-<para>Length of the section data, including headers and CRC,
- in buffer1.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>__u8* buffer2</para>
-</entry><entry
- align="char">
-<para>Pointer to the tail of the section data, or NULL. The
- pointer has a non-NULL value if the section wraps past
- the end of a circular buffer.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>size_t buffer2_length</para>
-</entry><entry
- align="char">
-<para>Length of the section data, including headers and CRC,
- in buffer2.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>__u16 pid</para>
-</entry><entry
- align="char">
-<para>The PID on which the section was received. Useful
- for obtaining the descrambling key, e.g. from a DVB
- Common Access facility.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-ENOSYS</para>
-</entry><entry
- align="char">
-<para>No descrambling facility available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>descramble_section_payload()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This function runs a descrambling algorithm on the payload of a DVB
- Datagram Section, replacing the original payload with its un-encrypted
- version. The function will be called from the demux API implementation;
- the API client need not call this function directly. Section-level scrambling
- algorithms are currently standardized only for DVB-RCC (return channel
- over 2-directional cable TV network) systems. For all other DVB networks,
- encryption schemes are likely to be proprietary to each data broadcaster. Thus,
- it is expected that this function pointer will have the value of NULL (i.e.,
- function not available) in most demux API implementations. Nevertheless, it
- should be possible to use the function pointer as a hook for dynamically adding
- a &#8220;plug-in&#8221; descrambling facility to a demux driver.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>While this function is not needed with hardware-based section descrambling,
- the descramble_section_payload function pointer can be used to override the
- default hardware-based descrambling algorithm: if the function pointer has a
- non-NULL value, the corresponding function should be used instead of any
- descrambling hardware.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int descramble_section_payload(dmx_demux_t&#x22C6; demux,
- __u8 &#x22C6;buffer1, size_t buffer1_length, __u8 &#x22C6;buffer2,
- size_t buffer2_length, __u16 pid);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>dmx_demux_t
- *demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>__u8 *buffer1</para>
-</entry><entry
- align="char">
-<para>Pointer to the first byte of the section.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>size_t buffer1_length</para>
-</entry><entry
- align="char">
-<para>Length of the section data, including headers and CRC,
- in buffer1.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>__u8 *buffer2</para>
-</entry><entry
- align="char">
-<para>Pointer to the tail of the section data, or NULL. The
- pointer has a non-NULL value if the section wraps past
- the end of a circular buffer.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>size_t buffer2_length</para>
-</entry><entry
- align="char">
-<para>Length of the section data, including headers and CRC,
- in buffer2.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>__u16 pid</para>
-</entry><entry
- align="char">
-<para>The PID on which the section was received. Useful
- for obtaining the descrambling key, e.g. from a DVB
- Common Access facility.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-ENOSYS</para>
-</entry><entry
- align="char">
-<para>No descrambling facility available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>add_frontend()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Registers a connectivity between a demux and a front-end, i.e., indicates that
- the demux can be connected via a call to connect_frontend() to use the given
- front-end as a TS source. The client of this function has to allocate dynamic or
- static memory for the frontend structure and initialize its fields before calling
- this function. This function is normally called during the driver initialization.
- The caller must not free the memory of the frontend struct before successfully
- calling remove_frontend().</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int add_frontend(dmx_demux_t &#x22C6;demux, dmx_frontend_t
- &#x22C6;frontend);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>dmx_demux_t*
- demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_frontend_t*
- frontend</para>
-</entry><entry
- align="char">
-<para>Pointer to the front-end instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EEXIST</para>
-</entry><entry
- align="char">
-<para>A front-end with the same value of the id field already
- registered.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINUSE</para>
-</entry><entry
- align="char">
-<para>The demux is in use.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-ENOMEM</para>
-</entry><entry
- align="char">
-<para>No more front-ends can be added.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>remove_frontend()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Indicates that the given front-end, registered by a call to add_frontend(), can
- no longer be connected as a TS source by this demux. The function should be
- called when a front-end driver or a demux driver is removed from the system.
- If the front-end is in use, the function fails with the return value of -EBUSY.
- After successfully calling this function, the caller can free the memory of
- the frontend struct if it was dynamically allocated before the add_frontend()
- operation.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int remove_frontend(dmx_demux_t&#x22C6; demux,
- dmx_frontend_t&#x22C6; frontend);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>dmx_demux_t*
- demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_frontend_t*
- frontend</para>
-</entry><entry
- align="char">
-<para>Pointer to the front-end instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EBUSY</para>
-</entry><entry
- align="char">
-<para>The front-end is in use, i.e. a call to connect_frontend()
- has not been followed by a call to disconnect_frontend().</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>get_frontends()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Provides the APIs of the front-ends that have been registered for this demux.
- Any of the front-ends obtained with this call can be used as a parameter for
- connect_frontend().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>The include file demux.h contains the macro DMX_FE_ENTRY() for
- converting an element of the generic type struct list_head* to the type
- dmx_frontend_t*. The caller must not free the memory of any of the elements
- obtained via this function call.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>struct list_head&#x22C6; get_frontends(dmx_demux_t&#x22C6; demux);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>dmx_demux_t*
- demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>dmx_demux_t*</para>
-</entry><entry
- align="char">
-<para>A list of front-end interfaces, or NULL in the case of an
- empty list.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>connect_frontend()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Connects the TS output of the front-end to the input of the demux. A demux
- can only be connected to a front-end registered to the demux with the function
- add_frontend().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>It may or may not be possible to connect multiple demuxes to the same
- front-end, depending on the capabilities of the HW platform. When not used,
- the front-end should be released by calling disconnect_frontend().</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int connect_frontend(dmx_demux_t&#x22C6; demux,
- dmx_frontend_t&#x22C6; frontend);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>dmx_demux_t*
- demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>dmx_frontend_t*
- frontend</para>
-</entry><entry
- align="char">
-<para>Pointer to the front-end instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EBUSY</para>
-</entry><entry
- align="char">
-<para>The front-end is in use.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section><section
-role="subsection"><title>disconnect_frontend()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>Disconnects the demux and a front-end previously connected by a
- connect_frontend() call.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int disconnect_frontend(dmx_demux_t&#x22C6; demux);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>dmx_demux_t*
- demux</para>
-</entry><entry
- align="char">
-<para>Pointer to the demux API and instance data.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURNS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>0</para>
-</entry><entry
- align="char">
-<para>The function was completed without errors.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>-EINVAL</para>
-</entry><entry
- align="char">
-<para>Bad parameter.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
- </section></section>
 <section id="demux_callback_api">
 <title>Demux Callback API</title>
 <para>This kernel-space API comprises the callback functions that deliver filtered data to the
diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 833191bcd810..54c3df38bb1b 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -202,10 +202,197 @@ struct dmx_frontend {
 
 #define DMX_FE_ENTRY(list) list_entry(list, struct dmx_frontend, connectivity_list)
 
+/**
+ * struct dmx_demux - Structure that contains the demux capabilities and
+ *		      callbacks.
+ *
+ * @capabilities: Bitfield of capability flags
+ *
+ * @frontend: Front-end connected to the demux
+ *
+ * @priv: Pointer to private data of the API client
+ *
+ * @open: This function reserves the demux for use by the caller and, if
+ *	necessary, initializes the demux. When the demux is no longer needed,
+ * 	the function close() should be called. It should be possible for
+ *	multiple clients to access the demux at the same time. Thus, the
+ *	function implementation should increment the demux usage count when
+ *	open() is called and decrement it when close() is called.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	It returns
+ *		0 on success;
+ * 		-EUSERS, if maximum usage count was reached;
+ *		-EINVAL, on bad parameter.
+ *
+ * @close: This function reserves the demux for use by the caller and, if
+ *	necessary, initializes the demux. When the demux is no longer needed,
+ *	the function close() should be called. It should be possible for
+ *	multiple clients to access the demux at the same time. Thus, the
+ *	function implementation should increment the demux usage count when
+ *	open() is called and decrement it when close() is called.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	It returns
+ *		0 on success;
+ *		-ENODEV, if demux was not in use
+ *		-EINVAL, on bad parameter.
+ *
+ * @write: This function provides the demux driver with a memory buffer
+ *	containing TS packets. Instead of receiving TS packets from the DVB
+ *	front-end, the demux driver software will read packets from memory.
+ *	Any clients of this demux with active TS, PES or Section filters will
+ *	receive filtered data via the Demux callback API (see 0). The function
+ *	returns when all the data in the buffer has been consumed by the demux.
+ *	Demux hardware typically cannot read TS from memory. If this is the
+ *	case, memory-based filtering has to be implemented entirely in software.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @buf function parameter contains a pointer to the TS data in
+ *	kernel-space memory.
+ *	The @count function parameter contains the length of the TS data.
+ *	It returns
+ *		0 on success;
+ *		-ENOSYS, if the command is not implemented;
+ *		-EINVAL, on bad parameter.
+ *
+ * @allocate_ts_feed: Allocates a new TS feed, which is used to filter the TS
+ *	packets carrying a certain PID. The TS feed normally corresponds to a
+ *	hardware PID filter on the demux chip.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @feed function parameter contains a pointer to the TS feed API and
+ *	instance data.
+ *	The @callback function parameter contains a pointer to the callback
+ *	function for passing received TS packet.
+ *	It returns
+ *		0 on success;
+ *		-EBUSY, if no more TS feeds is available;
+ *		-ENOSYS, if the command is not implemented;
+ *		-EINVAL, on bad parameter.
+ *
+ * @release_ts_feed: Releases the resources allocated with allocate_ts_feed().
+ *	Any filtering in progress on the TS feed should be stopped before
+ *	calling this function.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @feed function parameter contains a pointer to the TS feed API and
+ *	instance data.
+ *	It returns
+ *		0 on success;
+ *		-EINVAL on bad parameter.
+ *
+ * @allocate_section_feed: Allocates a new section feed, i.e. a demux resource
+ *	for filtering and receiving sections. On platforms with hardware
+ *	support for section filtering, a section feed is directly mapped to
+ *	the demux HW. On other platforms, TS packets are first PID filtered in
+ *	hardware and a hardware section filter then emulated in software. The
+ *	caller obtains an API pointer of type dmx_section_feed_t as an out
+ *	parameter. Using this API the caller can set filtering parameters and
+ *	start receiving sections.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @feed function parameter contains a pointer to the TS feed API and
+ *	instance data.
+ *	The @callback function parameter contains a pointer to the callback
+ *	function for passing received TS packet.
+ *	It returns
+ *		0 on success;
+ *		-EBUSY, if no more TS feeds is available;
+ *		-ENOSYS, if the command is not implemented;
+ *		-EINVAL, on bad parameter.
+ *
+ * @release_section_feed: Releases the resources allocated with
+ *	allocate_section_feed(), including allocated filters. Any filtering in
+ *	progress on the section feed should be stopped before calling this
+ *	function.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @feed function parameter contains a pointer to the TS feed API and
+ *	instance data.
+ *	It returns
+ *		0 on success;
+ *		-EINVAL, on bad parameter.
+ *
+ * @add_frontend: Registers a connectivity between a demux and a front-end,
+ *	i.e., indicates that the demux can be connected via a call to
+ *	connect_frontend() to use the given front-end as a TS source. The
+ *	client of this function has to allocate dynamic or static memory for
+ *	the frontend structure and initialize its fields before calling this
+ *	function. This function is normally called during the driver
+ *	initialization. The caller must not free the memory of the frontend
+ *	struct before successfully calling remove_frontend().
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @frontend function parameter contains a pointer to the front-end
+ *	instance data.
+ *	It returns
+ *		0 on success;
+ *		-EEXIST, if a front-end with the same value of the id field
+ *			already registered;
+ * 		-EINUSE, if the demux is in use;
+ *		-ENOMEM, if no more front-ends can be added;
+ *		-EINVAL, on bad parameter.
+ *
+ * @remove_frontend: Indicates that the given front-end, registered by a call
+ *	to add_frontend(), can no longer be connected as a TS source by this
+ *	demux. The function should be called when a front-end driver or a demux
+ *	driver is removed from the system. If the front-end is in use, the
+ *	function fails with the return value of -EBUSY. After successfully
+ *	calling this function, the caller can free the memory of the frontend
+ *	struct if it was dynamically allocated before the add_frontend()
+ *	operation.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @frontend function parameter contains a pointer to the front-end
+ *	instance data.
+ *	It returns
+ *		0 on success;
+ *		-EBUSY, if the front-end is in use, i.e. a call to
+ *			connect_frontend() has not been followed by a call to
+ *			disconnect_frontend();
+ *		-EINVAL, on bad parameter.
+ *
+ * @get_frontends: Provides the APIs of the front-ends that have been
+ *	registered for this demux. Any of the front-ends obtained with this
+ *	call can be used as a parameter for connect_frontend(). The include
+ *	file demux.h contains the macro DMX_FE_ENTRY() for converting an
+ *	element of the generic type struct list_head* to the type
+ * 	dmx_frontend_t*. The caller must not free the memory of any of the
+ *	elements obtained via this function call.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	It returns a struct list_head pointer to the list of front-end
+ *	interfaces, or NULL in the case of an empty list.
+ *
+ * @connect_frontend: Connects the TS output of the front-end to the input of
+ *	the demux. A demux can only be connected to a front-end registered to
+ *	the demux with the function add_frontend(). It may or may not be
+ *	possible to connect multiple demuxes to the same front-end, depending
+ *	on the capabilities of the HW platform. When not used, the front-end
+ *	should be released by calling disconnect_frontend().
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @frontend function parameter contains a pointer to the front-end
+ *	instance data.
+ *	It returns
+ *		0 on success;
+ *		-EBUSY, if the front-end is in use;
+ *		-EINVAL, on bad parameter.
+ *
+ * @disconnect_frontend: Disconnects the demux and a front-end previously
+ *	connected by a connect_frontend() call.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	It returns
+ *		0 on success;
+ *		-EINVAL on bad parameter.
+ */
+
 struct dmx_demux {
-	u32 capabilities;            /* Bitfield of capability flags */
-	struct dmx_frontend* frontend;    /* Front-end connected to the demux */
-	void* priv;                  /* Pointer to private data of the API client */
+	u32 capabilities;
+	struct dmx_frontend* frontend;
+	void* priv;
 	int (*open) (struct dmx_demux* demux);
 	int (*close) (struct dmx_demux* demux);
 	int (*write) (struct dmx_demux* demux, const char __user *buf, size_t count);
-- 
2.4.3


