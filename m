Return-path: <mchehab@pedra>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:32982 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934464Ab1ETQBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 12:01:15 -0400
Received: from mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.137])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 3A883A8074
	for <linux-media@vger.kernel.org>; Fri, 20 May 2011 18:01:13 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter8-d.gandi.net (mfilter8-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id h8vFckLVx7EU for <linux-media@vger.kernel.org>;
	Fri, 20 May 2011 18:01:11 +0200 (CEST)
Received: from WIN7PC (ALyon-157-1-245-199.w109-212.abo.wanadoo.fr [109.212.220.199])
	(Authenticated sender: sr@coexsi.fr)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 9E7EFA8076
	for <linux-media@vger.kernel.org>; Fri, 20 May 2011 18:01:11 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: <linux-media@vger.kernel.org>
Subject: [DVB] In research of chip's datasheets
Date: Fri, 20 May 2011 18:01:21 +0200
Message-ID: <008c01cc1707$29ea4290$7dbec7b0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear all,

I'm in research of datasheets of the following chips:
- tuner STV6110A from ST
- dual demodulator STV0900B from ST
- CI interface CXD2099AR from SONY

The main goal is first to understand how all these parts are working and
then to provide (if possible) some improvements.

The source code associated with these drivers is released under GPL terms,
but without any comments or descriptions in the code, so it's nearly useless
for people other than the original developers to understand and contribute
(that is basically the goal of the GPL spirit).

What is our advice regarding the procedure to have access to these
documents?

Best regards,
Sebastien.

