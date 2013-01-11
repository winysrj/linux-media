Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44301 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab3AKSik (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 13:38:40 -0500
Message-ID: <50F05C09.3010104@iki.fi>
Date: Fri, 11 Jan 2013 20:38:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: af9035 test needed!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jose and Gianluca

Could you test that (tda18218 & mxl5007t):
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/it9135_tuner

I wonder if ADC config logic still works for superheterodyne tuners 
(tuner having IF). I changed it to adc / 2 always due to IT9135 tuner. 
That makes me wonder it possible breaks tuners having IF, as ADC was 
clocked just over 20MHz and if it is half then it is 10MHz. For BB that 
is enough, but I think that having IF, which is 4MHz at least for 8MHz 
BW it is too less.

F*ck I hate to maintain driver without a hardware! Any idea where I can 
get AF9035 device having tda18218 or mxl5007t?

regards
Antti

-- 
http://palosaari.fi/
