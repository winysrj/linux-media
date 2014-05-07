Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35702 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaEGMzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 May 2014 08:55:07 -0400
Message-ID: <536A2D25.9020802@iki.fi>
Date: Wed, 07 May 2014 15:55:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>
Subject: V4L control units
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka
What is preferred way implement controls that could have some known unit 
or unknown unit? For example for gain controls, I would like to offer 
gain in unit of dB (decibel) and also some unknown driver specific unit. 
Should I two controls, one for each unit?

Like that

V4L2_CID_RF_TUNER_LNA_GAIN_AUTO
V4L2_CID_RF_TUNER_LNA_GAIN
V4L2_CID_RF_TUNER_LNA_GAIN_dB


regards
Antti

-- 
http://palosaari.fi/
