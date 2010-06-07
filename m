Return-path: <linux-media-owner@vger.kernel.org>
Received: from tuxmail.imn.htwk-leipzig.de ([141.57.7.10]:50678 "EHLO
	tuxmail.imn.htwk-leipzig.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474Ab0FGUp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 16:45:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by tuxmail.imn.htwk-leipzig.de (Postfix) with ESMTP id 607691516E
	for <linux-media@vger.kernel.org>; Mon,  7 Jun 2010 22:36:49 +0200 (CEST)
Received: from tuxmail.imn.htwk-leipzig.de ([141.57.7.10])
	by localhost (tuxmail.imn.htwk-leipzig.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sBb2KE22nXIh for <linux-media@vger.kernel.org>;
	Mon,  7 Jun 2010 22:36:45 +0200 (CEST)
Received: from baumbart.mittelerde.home (178-24-113-116-dynip.superkabel.de [178.24.113.116])
	by tuxmail.imn.htwk-leipzig.de (Postfix) with ESMTPSA id 7D02F1436F
	for <linux-media@vger.kernel.org>; Mon,  7 Jun 2010 22:36:45 +0200 (CEST)
From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>
Reply-To: tkrah@fachschaft.imn.htwk-leipzig.de
To: linux-media@vger.kernel.org
Subject: Pinnacle PCTV 70e Support question
Date: Mon, 7 Jun 2010 22:36:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006072236.44591.tkrah@fachschaft.imn.htwk-leipzig.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i wonder what needs to be done to support this usb stick also know as Pinnacle 
PCTV DVB-T (usb: eb1a:2870).
The stick has a MT2060 tuner and a Zarlink ZL10353 dvb frontend.

My kernel (2.6.32) does not "know" this board out-of-the-box but mention it as 
card=45 in dmesg.
But it does not work - using 45 as card type this is the result:

The support for this board weren't valid yet.

So what does it need to get stick and IR control working?

Torsten
