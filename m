Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40267 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893AbaLCPs1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 10:48:27 -0500
Date: Wed, 3 Dec 2014 17:47:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] Add LVDS RGB media bus formats
Message-ID: <20141203154752.GJ14746@valkosipuli.retiisi.org.uk>
References: <1417549284-5097-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417549284-5097-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tue, Dec 02, 2014 at 08:41:24PM +0100, Philipp Zabel wrote:
> This patch adds three new RGB media bus formats that describe
> 18-bit or 24-bit samples transferred over an LVDS bus with three
> or four differential data pairs, serialized into 7 time slots,
> using standard SPWG/PSWG/VESA or JEIDA data ordering.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 189 +++++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |   5 +-
>  2 files changed, 193 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 0d6f731..52d7f04 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -89,6 +89,11 @@
>        <constant>MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE</constant>.
>        </para>
>  
> +      <para>On LVDS buses, usually each sample is transferred in seven time slots
> +      on three (18-bit) or four (24-bit) differential data pairs at the same time.
> +      The remaining bits are used for control signals as defined by SPWG/PSWG/VESA
> +      or JEIDA standards.</para>
> +
>        <para>The following tables list existing packed RGB formats.</para>
>  
>        <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb">
> @@ -606,6 +611,190 @@
>  	  </tbody>
>  	</tgroup>
>        </table>
> +      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb-lvds">
> +	<title>LVDS RGB formats</title>
> +	<tgroup cols="11">
> +	  <colspec colname="id" align="left" />
> +	  <colspec colname="code" align="center" />
> +	  <colspec colname="pair" align="center" />
> +	  <colspec colname="slot" />
> +	  <colspec colnum="4" colname="s00" align="center" />
> +	  <colspec colnum="5" colname="s01" align="center" />
> +	  <colspec colnum="6" colname="s02" align="center" />
> +	  <colspec colnum="7" colname="s03" align="center" />
> +	  <colspec colnum="8" colname="s04" align="center" />
> +	  <colspec colnum="9" colname="s05" align="center" />
> +	  <colspec colnum="10" colname="s06" align="center" />
> +	  <spanspec namest="s00" nameend="s06" spanname="s0" />
> +	  <thead>
> +	    <row>
> +	      <entry>Identifier</entry>
> +	      <entry>Code</entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry spanname="s0">Data organization</entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>Pair</entry>
> +	      <entry>Slot</entry>
> +	      <entry>0</entry>
> +	      <entry>1</entry>
> +	      <entry>2</entry>
> +	      <entry>3</entry>
> +	      <entry>4</entry>
> +	      <entry>5</entry>
> +	      <entry>6</entry>
> +	    </row>
> +	  </thead>
> +	  <tbody valign="top">
> +	    <row id="MEDIA-BUS-FMT-RGB666-LVDS-SPWG">
> +	      <entry>MEDIA_BUS_FMT_RGB666_LVDS_SPWG</entry>
> +	      <entry>0x1010</entry>
> +	      <entry>data0</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>data1</entry>
> +	      <entry></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>data2</entry>
> +	      <entry></entry>
> +	      <entry>de</entry>
> +	      <entry>vs</entry>
> +	      <entry>hs</entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	    </row>
> +	    <row id="MEDIA-BUS-FMT-RGB888-LVDS-SPWG">
> +	      <entry>MEDIA_BUS_FMT_RGB888_LVDS_SPWG</entry>
> +	      <entry>0x1011</entry>
> +	      <entry>data0</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>data1</entry>
> +	      <entry></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>data2</entry>
> +	      <entry></entry>
> +	      <entry>de</entry>
> +	      <entry>vs</entry>
> +	      <entry>hs</entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>data3</entry>
> +	      <entry></entry>
> +	      <entry>ctl</entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	    </row>
> +	    <row id="MEDIA-BUS-FMT-RGB888-LVDS-JEIDA">
> +	      <entry>MEDIA_BUS_FMT_RGB888_LVDS_JEIDA</entry>
> +	      <entry>0x1012</entry>
> +	      <entry>data0</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>data1</entry>
> +	      <entry></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>data2</entry>
> +	      <entry></entry>
> +	      <entry>de</entry>
> +	      <entry>vs</entry>
> +	      <entry>hs</entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>data3</entry>
> +	      <entry></entry>
> +	      <entry>ctl</entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
> +	  </tbody>
> +	</tgroup>
> +      </table>

In general, I'd be more concerned with the pixel data itself than on low
level bus signalling related matters. For that reason I'd just say the
non-data bits are simply undefined.

We already support the CSI-2 bus, but the formats we use make no mention of
the standard itself. (A note to myself, they still should have been
separated from parallel format definitions.)

Could you instead create more generic format definitions that are not
specific to SPWG/PSWG/VESA or JEIDA?

I think this falls to the domain of the parallel-like interfaces since it
defines per bus pin which data is transferred over which pin. Is the wire
order defined by the above standards as well? It is exactly the opposite to
what is currently defined there.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
