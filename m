Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KWPq5-0003NO-1k
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 08:09:38 +0200
Message-ID: <48AE5818.1090102@iki.fi>
Date: Fri, 22 Aug 2008 09:09:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David <dvb-t@iinet.com.au>
References: <DA670E4156FE4C8DB883E07249860A77@CRAYXT5>
In-Reply-To: <DA670E4156FE4C8DB883E07249860A77@CRAYXT5>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB DVB-T Tuner with Alfa AF9015 + Philips TDA18211
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

David wrote:
> Hi All
> 
> I have been offered this low cost device.
> Just to enquire if any work is has already been done or is underway, to 
> support devices with this chipset and tuner combination.

Could you try http://linuxtv.org/hg/~anttip/af9015 . Download firmware 
from 
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
. It should work if your device has reference design USB-IDs, if not new 
USB-IDs should be added to the driver.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
