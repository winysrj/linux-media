Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KJFVT-0001CZ-9k
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 00:29:56 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out1.iol.cz (Postfix) with ESMTP id BBEA15EE78
	for <linux-dvb@linuxtv.org>; Thu, 17 Jul 2008 00:24:01 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 17 Jul 2008 00:23:57 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9TnfIkiZaNuAnlK"
Message-Id: <200807170023.57637.ajurik@quick.cz>
Subject: [linux-dvb] TT S2-3200 driver
Reply-To: ajurik@quick.cz
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_9TnfIkiZaNuAnlK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

please try attached patch. With this patch I'm able to get lock on channels 
before it was impossible. But not at all problematic channels and the 
reception is not without errors. Also it seems to me that channel switching is 
quicklier.

Within investigating I've found some problems, I've tried to compare data with 
data sent by BDA drivers under Windows (by monitoring i2c bus between stb0899 
and stb6100):

- under Windows stb6100 reports not so wide bandwith. (23-31MHz, 21-22MHz and 
so on).
- under Windows the gain is set by 1 or 2 higher.

When setting those parameters constantly to values used under Windows nothing 
change. So maybe some cooperation with stb0899 part of driver is necessary. 

Also it is interesting that clock speed of i2c bus is 278kHz, not 400kHz 
(measured with digital oscilloscope). But this should not have any influence.

Maybe somebody will be so capable to continue?

BR,

Ales

--Boundary-00=_9TnfIkiZaNuAnlK
Content-Type: application/x-zip;
  charset="us-ascii";
  name="stb6100.c.diff.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="stb6100.c.diff.zip"

UEsDBBQAAAAIAPsC8Tito2525wEAAO4EAAAOAAAAc3RiNjEwMC5jLmRpZmatU01v2kAUPJtfMacI
sA27NoEalwrZJDmUElT6oapCyMAWWXFstHaUHtL+9r61cYghVEWqD+v1W72ZebNj0zSRZssuZ6y1
aiUy3GgWY29M1jOZA4v3Wa9vOS1WPtAZndd0Xd+3PXfwLiy7b/f6neOO4RCm3bGNLnT14jaGwxo0
bSlFcOfS7lcNNV2TYpN+n33yFPJiNPbmGID9HPkunbWbTYzCNFhGAuPp1QTN9mGHKs9xMcDvl5V8
cakf0/EYUZJssS5w1pqmQAgm/IF6Xa6IbjfX4lGGmVgo+HqaBZkwoPaNBt6CNaiDmLMHGUOuSBwN
QPBekIplEK+xCcK4paCRA6eS+vFuAH5ZmNJQo2+IzHGBdhvQO1h7hUmOYzj0zboG54VJSnjyKCQe
ti3koK8M/TRAZebZt8lUe6rWbmf+FAc1j6zJrb9PIyG2davh7lSfYwcqdhzB/YPe4zsS8f6K/qqo
FPQSr5BX5XxdrDK9w7tGj0y3Lg3OCtPP4Pvi3x7QUeUE24EX177/vhpYVckXSkb+kCXj6TW8r1hF
yepuH12yxTxHpgI90JnTP0eagvhf8SgFJUicyPsgCtNdgvLouPlvd4ptIYN4I0rOi5yGzw3wvYDJ
5w8fr25mMGGfyiHKHNqM+P4AUEsBAhQDFAAAAAgA+wLxOK2jbnbnAQAA7gQAAA4ACQAAAAAAAAAA
AKSBAAAAAHN0YjYxMDAuYy5kaWZmVVQFAAf7dH5IUEsFBgAAAAABAAEARQAAABMCAAAAAA==

--Boundary-00=_9TnfIkiZaNuAnlK
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_9TnfIkiZaNuAnlK--
