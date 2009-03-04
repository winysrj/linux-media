Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59381 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZCDHtr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 02:49:47 -0500
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
Date: Wed, 4 Mar 2009 09:49:24 +0200
Cc: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <5e9665e10903021848u328e0cd4m5186344be15b817@mail.gmail.com> <5e9665e10903031642h2aa38c22o73a8db6714846031@mail.gmail.com> <200903040839.48104.hverkuil@xs4all.nl>
In-Reply-To: <200903040839.48104.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903040949.24666.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 March 2009 09:39:48 ext Hans Verkuil wrote:
> BTW, do I understand correctly that e.g. lens drivers also get their 
> own /dev/videoX node? Please tell me I'm mistaken! Since that would be so 
> very wrong.

You're mistaken :)

With the v4l2-int-interface/omap34xxcam camera driver one device
node consists of all slaves (sensor, lens, flash, ...) making up
the complete camera device.

> I hope that the conversion to v4l2_subdev will take place soon. You are 
> basically stuck in a technological dead-end :-(

Ok :(

- Tuukka
