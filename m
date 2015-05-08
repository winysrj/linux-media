Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35878 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbbEHKqK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 06:46:10 -0400
Message-ID: <554C93DE.2010205@xs4all.nl>
Date: Fri, 08 May 2015 12:45:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v6 07/11] DocBook/media: add CEC documentation
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com> <1430760785-1169-8-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430760785-1169-8-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

A few more comments about the documentation:

First of all you should add some documentation about what the passthrough mode
actually is. Right now all this says is that you can enable or disable it, but
not what it actually does.

And next I have a few small comments about the timestamp documentation:

> diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
> new file mode 100644
> index 0000000..cbde320
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
> @@ -0,0 +1,125 @@

...

> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>CEC devices can send asynchronous events. These can be retrieved by calling
> +    the <constant>CEC_G_EVENT</constant> ioctl. If the file descriptor is in non-blocking
> +    mode and no event is pending, then it will return -1 and set errno to the &EAGAIN;.</para>
> +
> +    <para>There can be up to 40 events queued up. If more events are added, then the oldest event will be discarded.</para>
> +
> +    <table pgwide="1" frame="none" id="cec-event">
> +      <title>struct <structname>cec_event</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u64</entry>
> +	    <entry><structfield>ts</structfield></entry>
> +	    <entry>Timestamp of the event in ns.</entry>

"Timestamp of the event in ns. This is based on the monotonic clock. Applications
can access this clock using <function>clock_gettime(2)</function> with clock ID
<constant>CLOCK_MONOTONIC</constant>. To turn this into a <structname>struct timespec</structname>
use:

<programlisting>
	struct timespec tmspec;

	tmspec.tv_sec = ts / 1000000000;
	tmspec.tv_nsec = ts % 1000000000;
<programlisting>"

(I hope the docbook syntax for programlisting is correct)

<snip>

> diff --git a/Documentation/DocBook/media/v4l/cec-ioc-receive.xml b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
> new file mode 100644
> index 0000000..dbec20a
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
> @@ -0,0 +1,185 @@

...

> +    <table pgwide="1" frame="none" id="cec-msg">
> +      <title>struct <structname>cec_msg</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u64</entry>
> +	    <entry><structfield>ts</structfield></entry>
> +	    <entry>Timestamp of when the message was transmitted in ns in the case
> +	    of <constant>CEC_TRANSMIT</constant> with <structfield>reply</structfield>
> +	    set to 0, or the timestamp of the received message in all other cases.</entry>

The same timestamp explanation should be given here.

Regards,

	Hans
