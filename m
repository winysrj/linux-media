Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:20714 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab1CaFjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 01:39:11 -0400
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIW002BDQD9CTB0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Mar 2011 14:39:09 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIW0000SQD9IG@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Mar 2011 14:39:09 +0900 (KST)
Date: Thu, 31 Mar 2011 14:39:09 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: [RFC] API for controlling Scenemode Preset
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D94137D.9020309@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello everyone,

This is a suggestion about the preset for the scenemode of camera. It's just
one API, and its role determines which current scenemode preset of camera is.

The kinds of scenemode are various at each camera. But, as you look around 
camera, the each scenemode has common name and the specific scenemode just
exist or not. So, I started to collect the scenemode common set of Fujitsu
M-5MOLS and NEC CE147. And, I found these modes are perfetly matched, althogh
the names are a little different.

I introduce these scenemode preset.

	Fujitsu M5MO		NEC CE147

	Portrait		Portrait
	Landscape		Landscape
	Sports			Sports
	Party & Indoor		Indoor & Party
	Beach & Snow		Beach & Snow
	Sunset			Sunset
	Dawn & Dusk		Dawn
	Fall			FallColor
	Night			Night
	Against Light		Against
	Fire			Fireworks
	Text			Text
	Candle			Candlelight

The camera just one scememode at one time, so these can be express by menu type
like this.

CID name
	: V4L2_CID_SCENEMODE

CID enumeration
	: enum v4l2_scenemode {
		V4L2_SCENEMODE_PORTRAIT	=	0,
		V4L2_SCENEMODE_LANDSCAPE	=	1,
		V4L2_SCENEMODE_SPORTS	=	2,
		V4L2_SCENEMODE_PARTY_INDOOR	=	3,
		V4L2_SCENEMODE_BEACH_SNOW	=	4,
		V4L2_SCENEMODE_SUNSET	=	5,
		V4L2_SCENEMODE_DAWN_DUSK	=	6,
		V4L2_SCENEMODE_FALLCOLOR	=	7,
		V4L2_SCENEMODE_NIGHT	=	8,
		V4L2_SCENEMODE_AGAINST_LIGHT	=	9,
		V4L2_SCENEMODE_FIREWORKS	=	10,
		V4L2_SCENEMODE_TEXT	=	11,
		V4L2_SCENEMODE_CANDLELIGHT	=	12,
	};

Thanks for reading, and welcome always any comments & opinions & any other cases.
I want to know any other case very much. :)

Ragards,
Heungjun Kim




