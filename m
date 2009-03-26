Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35467 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZCZWba (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 18:31:30 -0400
Subject: Re: [patch] add documentation for planar YUV 4:4:4 format
From: Andy Walls <awalls@radix.net>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <20090326150538.GB28126@emlix.com>
References: <1238077846-25751-1-git-send-email-dg@emlix.com>
	 <20090326150538.GB28126@emlix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Mar 2009 18:32:13 -0400
Message-Id: <1238106733.3319.2.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-03-26 at 16:05 +0100, Daniel Glöckner wrote:
> This patch adds the planar YUV 4:4:4 format to the v4l2 specification.
> 
> Signed-off-by: Daniel Glöckner <dg@emlix.com>
> 
> diff -r 55df63b82fef -r bd23aedbd597 v4l2-spec/Makefile
> --- a/v4l2-spec/Makefile	Thu Mar 26 09:13:40 2009 +0100
> +++ b/v4l2-spec/Makefile	Thu Mar 26 14:06:09 2009 +0100
> @@ -48,6 +48,7 @@
>  	pixfmt-yuv411p.sgml \
>  	pixfmt-yuv420.sgml \
>  	pixfmt-yuv422p.sgml \
> +	pixfmt-yuv444p.sgml \
>  	pixfmt-yuyv.sgml \
>  	pixfmt-yvyu.sgml \
>  	pixfmt.sgml \
> diff -r 55df63b82fef -r bd23aedbd597 v4l2-spec/pixfmt-yuv444p.sgml
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/v4l2-spec/pixfmt-yuv444p.sgml	Thu Mar 26 14:06:09 2009 +0100
> @@ -0,0 +1,171 @@
> +    <refentry id="V4L2-PIX-FMT-YUV444P">
> +      <refmeta>
> +	<refentrytitle>V4L2_PIX_FMT_YUV444P ('444P')</refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +	<refname><constant>V4L2_PIX_FMT_YUV444P</constant></refname>
> +	<refpurpose>Format with full horizontal and vertical chroma resolution,
> +also known as YUV 4:4:4. Planar layout</refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +	<para>This format is not commonly used. The three components are
> +separated into three sub-images or planes. The Y plane is first. The Cb plane
> +immediately follows the Y plane in memory. Following the Cb plane is the Cr
> +plane. All planes have on byte per pixel.</para>

s/on/one/


Regards,
Andy

> +	<para>If the Y plane has pad bytes after each row, then the Cr
> +and Cb planes have the same number of pad bytes after their rows. In other
> +words, one Cx row (including padding) is exactly as long as one Y row
> +(including padding).</para>
> +
> +	<example>
> +	  <title><constant>V4L2_PIX_FMT_YUV444P</constant> 4 &times; 4
> +pixel image</title>
> +
> +	  <formalpara>
> +	    <title>Byte Order.</title>
> +	    <para>Each cell is one byte.
> +		<informaltable frame="none">
> +		<tgroup cols="5" align="center">
> +		  <colspec align="left" colwidth="2*">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;0:</entry>
> +		      <entry>Y'<subscript>00</subscript></entry>
> +		      <entry>Y'<subscript>01</subscript></entry>
> +		      <entry>Y'<subscript>02</subscript></entry>
> +		      <entry>Y'<subscript>03</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;4:</entry>
> +		      <entry>Y'<subscript>10</subscript></entry>
> +		      <entry>Y'<subscript>11</subscript></entry>
> +		      <entry>Y'<subscript>12</subscript></entry>
> +		      <entry>Y'<subscript>13</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;8:</entry>
> +		      <entry>Y'<subscript>20</subscript></entry>
> +		      <entry>Y'<subscript>21</subscript></entry>
> +		      <entry>Y'<subscript>22</subscript></entry>
> +		      <entry>Y'<subscript>23</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;12:</entry>
> +		      <entry>Y'<subscript>30</subscript></entry>
> +		      <entry>Y'<subscript>31</subscript></entry>
> +		      <entry>Y'<subscript>32</subscript></entry>
> +		      <entry>Y'<subscript>33</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;16:</entry>
> +		      <entry>Cb<subscript>00</subscript></entry>
> +		      <entry>Cb<subscript>01</subscript></entry>
> +		      <entry>Cb<subscript>02</subscript></entry>
> +		      <entry>Cb<subscript>03</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;20:</entry>
> +		      <entry>Cb<subscript>10</subscript></entry>
> +		      <entry>Cb<subscript>11</subscript></entry>
> +		      <entry>Cb<subscript>12</subscript></entry>
> +		      <entry>Cb<subscript>13</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;24:</entry>
> +		      <entry>Cb<subscript>20</subscript></entry>
> +		      <entry>Cb<subscript>21</subscript></entry>
> +		      <entry>Cb<subscript>22</subscript></entry>
> +		      <entry>Cb<subscript>23</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;28:</entry>
> +		      <entry>Cb<subscript>30</subscript></entry>
> +		      <entry>Cb<subscript>31</subscript></entry>
> +		      <entry>Cb<subscript>32</subscript></entry>
> +		      <entry>Cb<subscript>33</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;32:</entry>
> +		      <entry>Cr<subscript>00</subscript></entry>
> +		      <entry>Cr<subscript>01</subscript></entry>
> +		      <entry>Cr<subscript>02</subscript></entry>
> +		      <entry>Cr<subscript>03</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;36:</entry>
> +		      <entry>Cr<subscript>10</subscript></entry>
> +		      <entry>Cr<subscript>11</subscript></entry>
> +		      <entry>Cr<subscript>12</subscript></entry>
> +		      <entry>Cr<subscript>13</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;40:</entry>
> +		      <entry>Cr<subscript>20</subscript></entry>
> +		      <entry>Cr<subscript>21</subscript></entry>
> +		      <entry>Cr<subscript>22</subscript></entry>
> +		      <entry>Cr<subscript>23</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;44:</entry>
> +		      <entry>Cr<subscript>30</subscript></entry>
> +		      <entry>Cr<subscript>31</subscript></entry>
> +		      <entry>Cr<subscript>32</subscript></entry>
> +		      <entry>Cr<subscript>33</subscript></entry>
> +		    </row>
> +		  </tbody>
> +		</tgroup>
> +		</informaltable>
> +	      </para>
> +	  </formalpara>
> +
> +	  <formalpara>
> +	    <title>Color Sample Location.</title>
> +	    <para>
> +		<informaltable frame="none">
> +		<tgroup cols="5" align="center">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry></entry>
> +		      <entry>0</entry><entry>1</entry>
> +		      <entry>2</entry><entry>3</entry>
> +		    </row>
> +		    <row>
> +		      <entry>0</entry>
> +		      <entry>Y/C</entry><entry>Y/C</entry>
> +		      <entry>Y/C</entry><entry>Y/C</entry>
> +		    </row>
> +		    <row>
> +		      <entry>1</entry>
> +		      <entry>Y/C</entry><entry>Y/C</entry>
> +		      <entry>Y/C</entry><entry>Y/C</entry>
> +		    </row>
> +		    <row>
> +		      <entry>2</entry>
> +		      <entry>Y/C</entry><entry>Y/C</entry>
> +		      <entry>Y/C</entry><entry>Y/C</entry>
> +		    </row>
> +		    <row>
> +		      <entry>3</entry>
> +		      <entry>Y/C</entry><entry>Y/C</entry>
> +		      <entry>Y/C</entry><entry>Y/C</entry>
> +		    </row>
> +		  </tbody>
> +		</tgroup>
> +		</informaltable>
> +	      </para>
> +	  </formalpara>
> +	</example>
> +      </refsect1>
> +    </refentry>
> +
> +  <!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "pixfmt.sgml"
> +indent-tabs-mode: nil
> +End:
> +  -->
> diff -r 55df63b82fef -r bd23aedbd597 v4l2-spec/pixfmt.sgml
> --- a/v4l2-spec/pixfmt.sgml	Thu Mar 26 09:13:40 2009 +0100
> +++ b/v4l2-spec/pixfmt.sgml	Thu Mar 26 14:06:09 2009 +0100
> @@ -596,6 +596,7 @@
>      &sub-y41p;
>      &sub-yuv420;
>      &sub-yuv410;
> +    &sub-yuv444p;
>      &sub-yuv422p;
>      &sub-yuv411p;
>      &sub-nv12;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

