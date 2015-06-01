Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38494 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbbFAJPW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 05:15:22 -0400
Message-ID: <556C229E.3020105@xs4all.nl>
Date: Mon, 01 Jun 2015 11:15:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] DocBook: some fixes for DVB FE open()
References: <6fd877748a9c4133e37417061e426188fcb00fea.1433149961.git.mchehab@osg.samsung.com>
In-Reply-To: <6fd877748a9c4133e37417061e426188fcb00fea.1433149961.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2015 11:12 AM, Mauro Carvalho Chehab wrote:
> The changeset dc9ef7d11207 change the open() ioctl documentation to
> match the V4L2 open(). However, some cut-and-pasted stuff doesn't
> match what actually happens at the DVB core.
> 
> So, fix the documentation entry to be more accurate with the DVB
> frontend open() specifics.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

I thought this might be necessary :-)

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> 
> diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
> index c7fa3d8bff5c..9d8e95cd9694 100644
> --- a/Documentation/DocBook/media/dvb/frontend.xml
> +++ b/Documentation/DocBook/media/dvb/frontend.xml
> @@ -61,7 +61,7 @@ specification is available at
>  
>  <refentry id="frontend_f_open">
>    <refmeta>
> -    <refentrytitle>open()</refentrytitle>
> +    <refentrytitle>DVB frontend open()</refentrytitle>
>      &manvol;
>    </refmeta>
>  
> @@ -94,20 +94,19 @@ specification is available at
>        <varlistentry>
>  	<term><parameter>flags</parameter></term>
>  	<listitem>
> -	  <para>Open flags. Access mode must be
> -<constant>O_RDWR</constant>. This is just a technicality, input devices
> -still support only reading and output devices only writing.</para>
> -	  <para>When the <constant>O_NONBLOCK</constant> flag is
> -given, the read() function will return the &EAGAIN; when no data is available,
> -otherwise these functions block until data becomes
> -available. Other flags have no effect.</para>
> +	  <para>Open flags. Access can either be
> +              <constant>O_RDWR</constant> or <constant>O_RDONLY</constant>.</para>
> +          <para>Multiple opens are allowed with <constant>O_RDONLY</constant>. In this mode, only query and read ioctls are allowed.</para>
> +          <para>Only one open is allowed in <constant>O_RDWR</constant>. In this mode, all ioctls are allowed.</para>
> +	  <para>When the <constant>O_NONBLOCK</constant> flag is given, the system calls may return &EAGAIN; when no data is available or when the device driver is temporarily busy.</para>
> +         <para>Other flags have no effect.</para>
>  	</listitem>
>        </varlistentry>
>      </variablelist>
>    </refsect1>
>    <refsect1>
>      <title>Description</title>
> -<para>This system call opens a named frontend device (/dev/dvb/adapter0/frontend0)
> +    <para>This system call opens a named frontend device (<constant>/dev/dvb/adapter?/frontend?</constant>)
>   for subsequent use. Usually the first thing to do after a successful open is to
>   find out the frontend type with <link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
>  <para>The device can be opened in read-only mode, which only allows monitoring of
> @@ -145,8 +144,7 @@ device.</para>
>        <varlistentry>
>  	<term><errorcode>EBUSY</errorcode></term>
>  	<listitem>
> -	  <para>The driver does not support multiple opens and the
> -device is already in use.</para>
> +	  <para>The the device driver is already in use.</para>
>  	</listitem>
>        </varlistentry>
>        <varlistentry>
> @@ -177,13 +175,19 @@ files open.</para>
>  system has been reached.</para>
>  	</listitem>
>        </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>ENODEV</errorcode></term>
> +	<listitem>
> +	  <para>The device got removed.</para>
> +	</listitem>
> +      </varlistentry>
>      </variablelist>
>    </refsect1>
>  </refentry>
>  
>  <refentry id="frontend_f_close">
>    <refmeta>
> -    <refentrytitle>close()</refentrytitle>
> +    <refentrytitle>DVB frontend close()</refentrytitle>
>      &manvol;
>    </refmeta>
>  
> 

