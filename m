Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37223 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967065Ab2EOXlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 19:41:36 -0400
Received: by wgbdr13 with SMTP id dr13so109566wgb.1
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 16:41:35 -0700 (PDT)
Message-ID: <4FB2E9AD.9050301@gmail.com>
Date: Wed, 16 May 2012 01:41:33 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L: JPEG class documentation corrections
References: <1333187035-28340-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1333187035-28340-1-git-send-email-sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I noticed that this patch and V2 that was only intended for merging,
are both in media tree now:

http://git.linuxtv.org/media_tree.git/history/579e92ffac65c717c9c8a50feb755a035a51bb3f:/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml

As a result Table A.58 has a redundant V4L2_CTRL_CLASS_JPEG entry:

...
V4L2_CTRL_CLASS_FLASH	0x9c0000	The class containing flash device controls. These controls are described in the section called “Flash Control Reference”.
V4L2_CTRL_CLASS_JPEG	0x9d0000	The class containing JPEG compression controls. These controls are described in the section called “JPEG Control Reference”.
V4L2_CTRL_CLASS_IMAGE_SOURCE	0x9e0000	The class containing image source controls. These controls are described in the section called “Image Source Control Reference”.
V4L2_CTRL_CLASS_IMAGE_PROC	0x9f0000	The class containing image processing controls. These controls are described in the section called “Image Process Control Reference”.
V4L2_CTRL_CLASS_JPEG	0x9d0000	The class containing JPEG compression controls. These controls are described in the section called “JPEG Control Reference”.

Thus I would suggest to revert the older patch - feed0258e11e04b7e0d2df8ae3793ab5d302a035
and remove redundant entry from the end of table.

Regards,
Sylwester

On 03/31/2012 11:43 AM, Sylwester Nawrocki wrote:
> This patch fixes following compilation warning:
> Error: no ID for constraint linkend: v4l2-jpeg-chroma-subsampling.
> 
> and adds missing JPEG control class at the Table A.58.
> 
> Signed-off-by: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
> ---
>   Documentation/DocBook/media/v4l/controls.xml       |    2 +-
>   .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +++++++
>   2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 582324f..8761e76 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -3546,7 +3546,7 @@ interface and may change in the future.</para>
>   	from RGB to Y'CbCr color space.
>   	</entry>
>   	</row>
> -	<row>
> +	<row id = "v4l2-jpeg-chroma-subsampling">
>   	<entrytbl spanname="descr" cols="2">
>   	<tbody valign="top">
>   		<row>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> index b17a7aa..27e20bc 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> @@ -265,7 +265,13 @@ These controls are described in<xref
>   These controls are described in<xref
>   		linkend="flash-controls" />.</entry>
>   	</row>
> +	<row>
> +	<entry><constant>V4L2_CTRL_CLASS_JPEG</constant></entry>
> +	<entry>0x9d0000</entry>
> +	<entry>The class containing JPEG compression controls.
> +These controls are described in<xref
> +		linkend="jpeg-controls" />.</entry>
> +	</row>
>   	</tbody>
>         </tgroup>
>       </table>
> --
> 1.7.4.1
> 

