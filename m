Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35608 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbbECK70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 06:59:26 -0400
Message-ID: <5545FF85.2050508@xs4all.nl>
Date: Sun, 03 May 2015 12:59:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v5 11/11] DocBook/media: add CEC documentation
References: <1430301765-22202-1-git-send-email-k.debski@samsung.com> <1430301765-22202-12-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430301765-22202-12-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some comments:

On 04/29/2015 12:02 PM, Kamil Debski wrote:
> From: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Add DocBook documentation for the CEC API.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> [k.debski@samsung.com: add documentation for passthrough mode]
> [k.debski@samsung.com: minor fixes and change of reserved field sizes]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  Documentation/DocBook/media/Makefile               |    4 +-
>  Documentation/DocBook/media/v4l/biblio.xml         |   10 +
>  Documentation/DocBook/media/v4l/cec-api.xml        |   74 ++++++
>  Documentation/DocBook/media/v4l/cec-func-close.xml |   59 +++++
>  Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   73 ++++++
>  Documentation/DocBook/media/v4l/cec-func-open.xml  |   94 +++++++
>  Documentation/DocBook/media/v4l/cec-func-poll.xml  |   89 +++++++
>  .../DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml |  275 ++++++++++++++++++++
>  .../DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml |   78 ++++++
>  .../DocBook/media/v4l/cec-ioc-g-adap-state.xml     |   87 +++++++
>  Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml |  167 ++++++++++++
>  .../DocBook/media/v4l/cec-ioc-g-event.xml          |  142 ++++++++++
>  .../DocBook/media/v4l/cec-ioc-g-vendor-id.xml      |   70 +++++
>  .../DocBook/media/v4l/cec-ioc-receive.xml          |  185 +++++++++++++
>  Documentation/DocBook/media_api.tmpl               |    6 +-
>  15 files changed, 1410 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/cec-api.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-state.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-vendor-id.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml
> 

<snip>

> diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml

<snip>

> +    <table pgwide="1" frame="none" id="cec-capabilities">
> +      <title>CEC Capabilities Flags</title>
> +      <tgroup cols="3">
> +	&cs-def;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry><constant>CEC_CAP_STATE</constant></entry>
> +	    <entry>0x00000001</entry>
> +	    <entry>Userspace has to configure the adapter state (enable or disable it) by
> +	    calling &CEC-S-ADAP-STATE;.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>CEC_CAP_PHYS_ADDR</constant></entry>
> +	    <entry>0x00000002</entry>
> +	    <entry>Userspace has to configure the physical address by
> +	    calling &CEC-S-ADAP-PHYS-ADDR;.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>CEC_CAP_LOG_ADDRS</constant></entry>
> +	    <entry>0x00000004</entry>
> +	    <entry>Userspace has to configure the logical addresses by
> +	    calling &CEC-S-ADAP-LOG-ADDRS;.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>CEC_CAP_TRANSMIT</constant></entry>
> +	    <entry>0x00000008</entry>
> +	    <entry>Userspace can transmit messages by calling &CEC-TRANSMIT;.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>CEC_CAP_RECEIVE</constant></entry>
> +	    <entry>0x00000010</entry>
> +	    <entry>Userspace can receive messages by calling &CEC-RECEIVE;.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>CEC_CAP_VENDOR_ID</constant></entry>
> +	    <entry>0x00000020</entry>
> +	    <entry>Userspace has to configure the vendor ID by
> +	    calling &CEC-S-VENDOR-ID;.</entry>
> +	  </row>

CAP_PASSTHROUGH is missing here.

> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
> new file mode 100644
> index 0000000..2b7e8e9
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml

<snip>

> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>CEC devices can send asynchronous events. These can be retrieved by calling
> +    the <constant>CEC_G_EVENT</constant> ioctl. If the file descriptor is in non-blocking
> +    mode and no event is pending, then it will return -1 and set errno to the &EAGAIN;.</para>

We should add something like this:

<para>There can be up to 16 events queued up. If more events are added, then the oldest
event will be discarded.</para>

I think we should increase the number of events to 40: given the speed of the bus (or lack
thereof) this should be more than sufficient provided the application will check events
at least once per second. The alternative would be to use a framework like v4l2_event, but
that is IMHO overkill for a bus like this.

<snip>

> +    <table pgwide="1" frame="none" id="cec-events">
> +      <title>CEC Events</title>
> +      <tgroup cols="3">
> +	&cs-def;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry><constant>CEC_EVENT_CONNECT</constant></entry>
> +	    <entry>1</entry>
> +	    <entry>Generated when the HDMI cable is connected.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>CEC_EVENT_READY</constant></entry>
> +	    <entry>2</entry>
> +	    <entry>Generated when all logical addresses are claimed.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>CEC_EVENT_DISCONNECT</constant></entry>
> +	    <entry>3</entry>
> +	    <entry>Generated when the HDMI cable is disconnected.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>CEC_EVENT_GOT_REPLY</constant></entry>
> +	    <entry>4</entry>
> +	    <entry>Generated when a prely is received for a previously sent

prely -> reply

> +	    message. Generated only if a reply was requested and only if the
> +	    message was sent in non-blocking mode.</entry>

Looking at the code in cec.c, cec_received_msg():

	if (!is_reply || (is_reply && !dst_data->blocking))
		adap->recv_notifier(adap, msg);
	if (is_reply)
		cec_post_event(adap, CEC_EVENT_GOT_REPLY, msg->sequence);
}

it seems that the event is posted also if dst_data->blocking is true.

That conflicts with the documentation. I think the code should follow the
documentation.

<snip>

Finally, the passthrough documentation is missing, did you forget to do
'git add'?

Regards,

	Hans
