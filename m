Return-path: <mchehab@pedra>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:57725 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311Ab1BPF5c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 00:57:32 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Feb 2011 13:57:11 +0800
Subject: soc-camera: Benefits of soc-camera interface over specific char
 drivers that use Gstreamer lib
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

As I mentioned in one of my previous mails , we are developing a Camera Host and
Sensor driver for our ST specific SoC and considering using the soc-camera framework
for the same. One of our open-source customers has raised a interesting case though:

It seems they have an existing solution (for another SoC) in which they do not use V4L2
framework and instead use the Gstreamer with framebuffer. They specifically wish us to
implement a solution which is compatible with ANDROID applications.

Could you please help us in deciding which approach is preferable in terms of
performance, maintenance and ease-of-design.

Thanks for your help.

Regards,
Bhupesh
ST Microelectronics
