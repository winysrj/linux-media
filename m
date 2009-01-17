Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36855 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbZAQBiM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 20:38:12 -0500
Message-ID: <4971367E.90504@iki.fi>
Date: Sat, 17 Jan 2009 03:38:06 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: Detlef Rohde <rohde.d@t-online.de>,
	Roberto Ragusa <mail@robertoragusa.it>,
	linux-media@vger.kernel.org
Subject: Re: MC44S803 frontend (it works)
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de> <49623372.90403@robertoragusa.it> <4965327A.5000605@t-online.de> <496CD4C8.50004@t-online.de> <496E2C6B.3050607@scram.de> <496E2FB5.4080406@scram.de>
In-Reply-To: <496E2FB5.4080406@scram.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I just pushed Jochen's MC44S803 driver to linuxtv.org devel tree. I did 
some changes to patch that adds this tuner to AF9015, because patch 
didn't applied and also some other changes. Hopefully it doesn't break 
functionality. Please test.

http://linuxtv.org/hg/~anttip/mc44s803/

regards
Antti
-- 
http://palosaari.fi/
