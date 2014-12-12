Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57782 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753453AbaLLXHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 18:07:54 -0500
Date: Sat, 13 Dec 2014 01:07:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] Add LVDS RGB media bus formats
Message-ID: <20141212230745.GA17565@valkosipuli.retiisi.org.uk>
References: <1418403062-15663-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418403062-15663-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pilipp,

On Fri, Dec 12, 2014 at 05:51:02PM +0100, Philipp Zabel wrote:
> This patch adds three new RGB media bus formats that describe
> 18-bit or 24-bit samples transferred over an LVDS bus with three
> or four differential data pairs, serialized into 7 time slots,
> using standard SPWG/PSWG/VESA or JEIDA data ordering.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 253 +++++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |   5 +-
>  2 files changed, 257 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 0d6f731..6d59a0e 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -89,6 +89,14 @@
>        <constant>MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE</constant>.
>        </para>
>  
> +      <para>On LVDS buses, usually each sample is transferred serialized in seven

80 characters per line, please.

Could you move this paragraph just before the LVDS table?

> +      time slots per pixel clock, on three (18-bit) or four (24-bit) differential
> +      data pairs at the same time. The remaining bits are used for control signals
> +      as defined by SPWG/PSWG/VESA or JEIDA standards. The 24-bit RGB format serialized
> +      in seven time slots on four lanes using JEIDA defined bit mapping will be
> +      named <constant>MEDIA_BUS_FMT_RGB888_1X7X3_JEIDA</constant>, for example.
> +      </para>
> +
>        <para>The following tables list existing packed RGB formats.</para>
>  
>        <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb">
> @@ -606,6 +614,251 @@
>  	  </tbody>
>  	</tgroup>
>        </table>
> +      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb-lvds">
> +	<title>LVDS RGB formats</title>
> +	<tgroup cols="8">
> +	  <colspec colname="id" align="left" />
> +	  <colspec colname="code" align="center" />
> +	  <colspec colname="slot" align="center" />
> +	  <colspec colname="lane" />
> +	  <colspec colnum="5" colname="l03" align="center" />
> +	  <colspec colnum="6" colname="l02" align="center" />
> +	  <colspec colnum="7" colname="l01" align="center" />
> +	  <colspec colnum="8" colname="l00" align="center" />
> +	  <spanspec namest="l03" nameend="l00" spanname="l0" />
> +	  <thead>
> +	    <row>
> +	      <entry>Identifier</entry>
> +	      <entry>Code</entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry spanname="l0">Data organization</entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>Timeslot</entry>
> +	      <entry>Lane</entry>
> +	      <entry>3</entry>
> +	      <entry>2</entry>
> +	      <entry>1</entry>
> +	      <entry>0</entry>
> +	    </row>
> +	  </thead>
> +	  <tbody valign="top">
> +	    <row id="MEDIA-BUS-FMT-RGB666-1X7X3-SPWG">
> +	      <entry>MEDIA_BUS_FMT_RGB666_1X7X3_SPWG</entry>
> +	      <entry>0x1010</entry>
> +	      <entry>0</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>d</entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>1</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>d</entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>2</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>d</entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>3</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>4</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>5</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>6</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="MEDIA-BUS-FMT-RGB888-1X7X4-SPWG">
> +	      <entry>MEDIA_BUS_FMT_RGB888_1X7X4_SPWG</entry>
> +	      <entry>0x1011</entry>
> +	      <entry>0</entry>
> +	      <entry></entry>
> +	      <entry>d</entry>
> +	      <entry>d</entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>1</entry>
> +	      <entry></entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>d</entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>2</entry>
> +	      <entry></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>d</entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>3</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>4</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>5</entry>
> +	      <entry></entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>6</entry>
> +	      <entry></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="MEDIA-BUS-FMT-RGB888-1X7X4-JEIDA">
> +	      <entry>MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA</entry>
> +	      <entry>0x1012</entry>
> +	      <entry>0</entry>
> +	      <entry></entry>
> +	      <entry>d</entry>
> +	      <entry>d</entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>1</entry>
> +	      <entry></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>d</entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>2</entry>
> +	      <entry></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>d</entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>3</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>4</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>5</entry>
> +	      <entry></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>6</entry>
> +	      <entry></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	    </row>
> +	  </tbody>
> +	</tgroup>
> +      </table>
>      </section>
>  
>      <section>
> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> index 37091c6..3fb9cbb 100644
> --- a/include/uapi/linux/media-bus-format.h
> +++ b/include/uapi/linux/media-bus-format.h
> @@ -33,7 +33,7 @@
>  
>  #define MEDIA_BUS_FMT_FIXED			0x0001
>  
> -/* RGB - next is	0x1010 */

Does your patch depend on another patch which is not merged yet?

> +/* RGB - next is	0x1013 */
>  #define MEDIA_BUS_FMT_RGB444_1X12		0x100e
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
> @@ -45,9 +45,12 @@
>  #define MEDIA_BUS_FMT_RGB565_2X8_BE		0x1007
>  #define MEDIA_BUS_FMT_RGB565_2X8_LE		0x1008
>  #define MEDIA_BUS_FMT_RGB666_1X18		0x1009
> +#define MEDIA_BUS_FMT_RGB666_1X7X3_SPWG		0x1010
>  #define MEDIA_BUS_FMT_RGB888_1X24		0x100a
>  #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
>  #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
> +#define MEDIA_BUS_FMT_RGB888_1X7X4_SPWG		0x1011
> +#define MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA	0x1012
>  #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
>  
>  /* YUV (including grey) - next is	0x2024 */

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
