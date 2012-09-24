Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:32891 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419Ab2IXO7C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:59:02 -0400
From: Vincent ABRIOU <vincent.abriou@st.com>
To: "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Willy POISSON <willy.poisson@st.com>,
	Nicolas THERY <nicolas.thery@st.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>
Date: Mon, 24 Sep 2012 16:58:34 +0200
Subject: RE: [RFC] Frame format descriptors
Message-ID: <9481210134BDC5419AC503D05B6CA44F34B74D90D3@SAFEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari

Thank you for sharing your opinion on this subject.
I know that for you it is an old topics but I would like to revive this RFC by asking you some questions about your proposal in order to move forward on this subject.

Indeed, stream format description is very important and mandatory for every CSI-2 receiver in order to be well configured.  

I understand from your proposal that frame format descriptor is defined by the sensor/camera and retrieve by the CSI-2 receiver. 
Since the CSI-2 stream to capture does not have multiple pixel format (one pixel format but multiple embedded data) it does not bring so many complexity.

But I have some difficulties to put things together in case of a sensor/camera providing
2 interleaved streams with 2 different pixel format such JPEG interleaved with YUV.
In that case, what is the external trigger from the client to warn sensor/camera that the client is requesting an interleaved stream? New mbus pixel code added in the v4l2_mbus_pixelcode enum and defined in the sensor/camera pad? 

Kind regards,

--
Vincent Abriou

