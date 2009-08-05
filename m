Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.mail.tnz.yahoo.co.jp ([203.216.226.136]:20886 "HELO
	smtp08.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933310AbZHEC7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Aug 2009 22:59:05 -0400
Message-ID: <4A78F3E6.2090708@yahoo.co.jp>
Date: Wed, 05 Aug 2009 11:52:22 +0900
From: Akihiro TSUKADA <tskd2@yahoo.co.jp>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	olgrenie@dibcom.fr
Subject: Re: RFC: adding ISDB-T/ISDB-Tsb to DVB-API 5
References: <alpine.LRH.1.10.0908031943220.8512@pub1.ifh.de> <alpine.LRH.1.10.0908041617050.8512@pub1.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0908041617050.8512@pub1.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

Thank you for your effort to add support for ISDB-T/S.
I've skimmed through the ARIB standard before,
but it is too complicated for me to understand well enough.
So this is not a comment for the API extension itself,
but for the document part.

Some of the parameters are currently (and probably will stay)
fixed or not used  according to the "operational guidelines".
For example, DQPSK is not used at all (if I read correctly).
These guidelines are defined in ARIB TR-B14 for ISDB-T and
in ARIB TR-B15 for ISDB-S respectively.

So, including these two TRs (in additino to ARIB STD-B31)
as a reference in the document may help readers.
---------
Akihiro TSUKADA
--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
