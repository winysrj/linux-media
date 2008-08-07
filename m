Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12] helo=amy.cooptel.qc.ca)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rlemieu@cooptel.qc.ca>) id 1KQvPw-0006SM-Ri
	for linux-dvb@linuxtv.org; Thu, 07 Aug 2008 04:39:57 +0200
Message-ID: <489A6058.1060602@cooptel.qc.ca>
Date: Wed, 06 Aug 2008 22:39:20 -0400
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problems with scan
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

Hi,

I reported earlier that the following command didn't lock anything with
my TBS8920 under kernel 2.6.24.3.

   scan dvb-s/Galaxy3C-95w

but kaffeine's scan is successful.

So I built a one line channels.conf file from what I see in file
channels.dvb as created by kaffeine.

   echo 'CCTV 4-1:11780:h::20760:512:650:1' >~/.szap/channels.conf

Now 'szap -n 1' locks on a channel,

   status 1f | signal d7c0 | snr ee67 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

So I try again scan with the -c option, creating a supposedly correct conf file,

   scan -q -c -o zap > ~/.szap/channels.conf

CCTV 4:11070:v:0:27500:512:650:1
CCTV 9:11070:v:0:27500:513:660:2
CCTV F:11070:v:0:27500:514:670:3
CCTV E:11070:v:0:27500:518:710:7

Now trying szap again but with the new channels.conf written by 'scan'
results in no lock

   status 01 | signal c0c0 | snr 0000 | ber 00000000 | unc 00000000 |

Would anyone have a suggestion where to look next.

Thanks

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
