Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45044 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183AbbBPMXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 07:23:00 -0500
Message-ID: <54E1E110.2010903@xs4all.nl>
Date: Mon, 16 Feb 2015 13:22:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Miguel Casas-Sanchez <mcasas@chromium.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: docs: Correct NV{12,21}/M pixel formats, chroma
 samples used.
References: <CAPUS087-jTACBQbH=Kqby3S52Ff4kKoswRuubUoC6Y=OoNz2yQ@mail.gmail.com>
In-Reply-To: <CAPUS087-jTACBQbH=Kqby3S52Ff4kKoswRuubUoC6Y=OoNz2yQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/2015 08:32 PM, Miguel Casas-Sanchez wrote:
> Docos says for these pixel formats:
> 
> start... : Cb00 Cr00 Cb01 Cr01
> start... : Cb10 Cr10 Cb11 Cr11
> 
> whereas it should read:
> 
> start... : Cb00 Cr00 Cb11 Cr11
> start... : Cb20 Cr20 Cb21 Cr21
> 
> where ... depends on the exact multi/single planar format.
> 
> See e.g. http://linuxtv.org/downloads/v4l-dvb-apis/re30.html
> and http://linuxtv.org/downloads/v4l-dvb-apis/re31.html
> 
> 
> Signed-off-by: Miguel Casas-Sanchez <mcasas@chromium.org>

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

The Chroma coordinates are those of the CbCr plane, not the luma
plane. This is true for all other YCbCr format descriptions as well.

Regards,

	Hans

> ---
>  Documentation/DocBook/media/v4l/pixfmt-nv12.xml  |  8 ++++----
>  Documentation/DocBook/media/v4l/pixfmt-nv12m.xml | 12 ++++++------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
> b/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
> index 84dd4fd..4148696 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
> @@ -73,15 +73,15 @@ pixel image</title>
>                       <entry>start&nbsp;+&nbsp;16:</entry>
>                       <entry>Cb<subscript>00</subscript></entry>
>                       <entry>Cr<subscript>00</subscript></entry>
> -                     <entry>Cb<subscript>01</subscript></entry>
> -                     <entry>Cr<subscript>01</subscript></entry>
> +                     <entry>Cb<subscript>02</subscript></entry>
> +                     <entry>Cr<subscript>02</subscript></entry>
>                     </row>
>                     <row>
>                       <entry>start&nbsp;+&nbsp;20:</entry>
>                       <entry>Cb<subscript>10</subscript></entry>
>                       <entry>Cr<subscript>10</subscript></entry>
> -                     <entry>Cb<subscript>11</subscript></entry>
> -                     <entry>Cr<subscript>11</subscript></entry>
> +                     <entry>Cb<subscript>22</subscript></entry>
> +                     <entry>Cr<subscript>22</subscript></entry>
>                     </row>
>                   </tbody>
>                 </tgroup>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
> b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
> index f3a3d45..e0a35ea 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
> @@ -83,15 +83,15 @@ CbCr plane has as many pad bytes after its rows.</para>
>                       <entry>start1&nbsp;+&nbsp;0:</entry>
>                       <entry>Cb<subscript>00</subscript></entry>
>                       <entry>Cr<subscript>00</subscript></entry>
> -                     <entry>Cb<subscript>01</subscript></entry>
> -                     <entry>Cr<subscript>01</subscript></entry>
> +                     <entry>Cb<subscript>02</subscript></entry>
> +                     <entry>Cr<subscript>02</subscript></entry>
>                     </row>
>                     <row>
>                       <entry>start1&nbsp;+&nbsp;4:</entry>
> -                     <entry>Cb<subscript>10</subscript></entry>
> -                     <entry>Cr<subscript>10</subscript></entry>
> -                     <entry>Cb<subscript>11</subscript></entry>
> -                     <entry>Cr<subscript>11</subscript></entry>
> +                     <entry>Cb<subscript>20</subscript></entry>
> +                     <entry>Cr<subscript>20</subscript></entry>
> +                     <entry>Cb<subscript>22</subscript></entry>
> +                     <entry>Cr<subscript>22</subscript></entry>
>                     </row>
>                   </tbody>
>                 </tgroup>
> 
> --
> 2.2.0.rc0.207.ga3a616c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

