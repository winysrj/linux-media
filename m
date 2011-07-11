Return-path: <mchehab@localhost>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49367 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab1GKK6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 06:58:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: Re: [PATCH 2/3] Document 8-bit and 16-bit YCrCb media bus pixel codes
Date: Mon, 11 Jul 2011 12:58:49 +0200
Cc: linux-media@vger.kernel.org
References: <CAH9NwWc+zLqPyBcC99wbsbNkdjzMFfn2zuGm1VfmZctgpOGMew@mail.gmail.com>
In-Reply-To: <CAH9NwWc+zLqPyBcC99wbsbNkdjzMFfn2zuGm1VfmZctgpOGMew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111258.50144.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Christian,

On Sunday 10 July 2011 20:14:21 Christian Gmeiner wrote:
> Signed-off-by: Christian Gmeiner
> ---
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
> b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 49c532e..18e30b0 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -2565,5 +2565,43 @@
>         </tgroup>
>        </table>
>      </section>
> +
> +    <section>
> +      <title>YCrCb Formats</title>
> +
> +      <para>YCbCr represents colors as a combination of three values:
> +      <itemizedlist>
> +       <listitem><para>Y - the luminosity (roughly the
> brightness)</para></listitem>
> +       <listitem><para>Cb - the chrominance of the blue
> primary</para></listitem>
> +       <listitem><para>Cr - the chrominance of the red
> primary</para></listitem>

How does that differ from YUV ?

> +      </itemizedlist>
> +      </para>
> +
> +      <para>The following table lists existing YCrCb compressed
> formats.</para> +
> +      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-ycrcb">
> +       <title>YCrCb Formats</title>
> +       <tgroup cols="2">
> +         <colspec colname="id" align="left" />
> +         <colspec colname="code" align="left"/>
> +         <thead>
> +           <row>
> +             <entry>Identifier</entry>
> +             <entry>Code</entry>
> +           </row>
> +         </thead>
> +         <tbody valign="top">
> +           <row id="V4L2_MBUS_FMT_YCRCB_1X8">
> +             <entry>V4L2_MBUS_FMT_YCRCB_1X8</entry>
> +             <entry>0x5001</entry>
> +           </row>
> +           <row id="V4L2_MBUS_FMT_YCRCB_1X16">
> +             <entry>V4L2_MBUS_FMT_YCRCB_1X16</entry>
> +             <entry>0x5002</entry>
> +           </row>
> +         </tbody>
> +       </tgroup>
> +       </table>
> +    </section>
>    </section>
>  </section>

-- 
Regards,

Laurent Pinchart
