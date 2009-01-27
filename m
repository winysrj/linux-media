Return-path: <linux-media-owner@vger.kernel.org>
Received: from mognix.dark-green.com ([88.116.226.179]:51196 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZA0Ujy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 15:39:54 -0500
Message-ID: <497F7117.9000607@dark-green.com>
Date: Tue, 27 Jan 2009 21:39:51 +0100
From: gimli <gimli@dark-green.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Broken Tuning on Wintv Nova HD S2
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the following changesets breaks Tuning to Vertical Transponders :

http://mercurial.intuxication.org/hg/s2-liplianin/rev/1ca67881d96a
http://linuxtv.org/hg/v4l-dvb/rev/2cd7efb4cc19

For example :

DMAX;BetaDigital:12246:vC34M2O0S0:S19.2E:27500:511:512=deu:32:0:10101:1:1092:0


cu

Edgar ( gimli ) Hucek
