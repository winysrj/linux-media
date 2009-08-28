Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:65293 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZH1KNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 06:13:33 -0400
Message-ID: <4A97ADCD.6060200@googlemail.com>
Date: Fri, 28 Aug 2009 11:13:33 +0100
From: Peter Brouwer <pb.maillists@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
	Linux Input <linux-input@vger.kernel.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [RFC] Infrared Keycode standardization
References: <20090827045710.2d8a7010@pedra.chehab.org>	<20090827183636.GG26702@sci.fi>	<20090827185853.0aa2de76@pedra.chehab.org>	<829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>	<20090828004628.06f34d12@pedra.chehab.org> <20090828041459.67c1499a@pedra.chehab.org>
In-Reply-To: <20090828041459.67c1499a@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Would like to add one more dimension to the discussion.

The situation of having multiple DVB type boards in one system.

Using one remote would be enough to control the system. So we should have a 
mechanism/kernel config option, to enable/disable an IR device on a board.
For multiple boards of the same type, enable the first and disable any 
subsequently detected boards.

Peter

> 

