Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1468 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaAYI1M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 03:27:12 -0500
Message-ID: <52E37554.3070203@xs4all.nl>
Date: Sat, 25 Jan 2014 09:27:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 11/13] DocBook: mark SDR API as Experimental
References: <1390511333-25837-1-git-send-email-crope@iki.fi> <1390511333-25837-12-git-send-email-crope@iki.fi>
In-Reply-To: <1390511333-25837-12-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

On 01/23/2014 10:08 PM, Antti Palosaari wrote:
> Let it be experimental still as all SDR drivers are in staging.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/compat.xml  | 3 +++
>  Documentation/DocBook/media/v4l/dev-sdr.xml | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 83f64ce..2fb2b8d 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2661,6 +2661,9 @@ ioctls.</para>
>          <listitem>
>  	  <para>Exporting DMABUF files using &VIDIOC-EXPBUF; ioctl.</para>
>          </listitem>
> +        <listitem>
> +	  <para>Software Defined Radio (SDR) Interface, <xref linkend="sdr" />.</para>
> +        </listitem>
>        </itemizedlist>
>      </section>
>  
> diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
> index 332b87f..ac9f1af 100644
> --- a/Documentation/DocBook/media/v4l/dev-sdr.xml
> +++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
> @@ -1,5 +1,11 @@
>    <title>Software Defined Radio Interface (SDR)</title>
>  
> +  <note>
> +    <title>Experimental</title>
> +    <para>This is an <link linkend="experimental"> experimental </link>
> +    interface and may change in the future.</para>
> +  </note>
> +
>    <para>
>  SDR is an abbreviation of Software Defined Radio, the radio device
>  which uses application software for modulation or demodulation. This interface
> 
