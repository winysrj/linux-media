Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44429 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2IGUAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 16:00:13 -0400
Received: by eekc1 with SMTP id c1so1418058eek.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 13:00:12 -0700 (PDT)
Message-ID: <504A5249.4000602@gmail.com>
Date: Fri, 07 Sep 2012 22:00:09 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 04/28] DocBook: make the G/S/TRY_FMT specification
 more strict.
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <5c449812e54fff0816282e712ab9e24c8b278cb6.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <5c449812e54fff0816282e712ab9e24c8b278cb6.1347023744.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> - S/TRY_FMT should always succeed, unless an invalid type field is passed in.
> - TRY_FMT should give the same result as S_FMT, all other things being equal.
> - ENUMFMT may return different formats for different inputs or outputs.
>
> This was decided during the 2012 Media Workshop.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

A typo managed to snick in below...

> ---
>   Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml |    3 +++
>   Documentation/DocBook/media/v4l/vidioc-g-fmt.xml    |    9 ++++++---
>   2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
> index 81ebe48..0bd3324 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
> @@ -58,6 +58,9 @@ structure. Drivers fill the rest of the structure or return an
>   incrementing by one until<errorcode>EINVAL</errorcode>  is
>   returned.</para>
>
> +<para>Note that after switching input or output the list of enumerated image
> +formats may be different.</para>
> +
>       <table pgwide="1" frame="none" id="v4l2-fmtdesc">
>         <title>struct<structname>v4l2_fmtdesc</structname></title>
>         <tgroup cols="3">
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> index 52acff1..9ef279a 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> @@ -81,7 +81,7 @@ the application calls the<constant>VIDIOC_S_FMT</constant>  ioctl
>   with a pointer to a<structname>v4l2_format</structname>  structure
>   the driver checks
>   and adjusts the parameters against hardware abilities. Drivers
> -should not return an error code unless the input is ambiguous, this is
> +should not return an error code unless the<structfield>type</structfield>  field is invalid, this is
>   a mechanism to fathom device capabilities and to approach parameters
>   acceptable for both the application and driver. On success the driver
>   may program the hardware, allocate resources and generally prepare for
> @@ -107,6 +107,10 @@ disabling I/O or possibly time consuming hardware preparations.
>   Although strongly recommended drivers are not required to implement
>   this ioctl.</para>
>
> +<para>The format as returned by<constant>VIDIOC_TRY_FMT</constant>
> +must be identical to what<constant>VIDIOC_S_FMT</constant>  returns for
> +the same input or output.</para>
> +
>       <table pgwide="1" frame="none" id="v4l2-format">
>         <title>struct<structname>v4l2_format</structname></title>
>         <tgroup cols="4">
> @@ -187,8 +191,7 @@ capture and output devices.</entry>
>   	<term><errorcode>EINVAL</errorcode></term>
>   	<listitem>
>   	<para>The&v4l2-format;<structfield>type</structfield>
> -field is invalid, the requested buffer type not supported, or the
> -format is not supported with this buffer type.</para>
> +field is invalia or the requested buffer type not supported.</para>

invalia -> invalid

>   	</listitem>
>         </varlistentry>
>       </variablelist>

--

Regards,
Sylwester
