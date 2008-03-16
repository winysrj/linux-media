Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47DC64F4.9070403@iki.fi>
Date: Sun, 16 Mar 2008 02:08:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47D9EED4.8090303@linuxtv.org>	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>	<47DA0F01.8010707@iki.fi>
	<47DA7008.8010404@linuxtv.org>	<47DAC42D.7010306@iki.fi>
	<47DAC4BE.5090805@iki.fi>	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>	<abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>	<47DBDB9F.5060107@iki.fi>
	<abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>
In-Reply-To: <abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------010904050205080903030705"
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

This is a multi-part message in MIME format.
--------------010904050205080903030705
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jarryd Beck wrote:
> On Sun, Mar 16, 2008 at 1:22 AM, Antti Palosaari <crope@iki.fi> wrote:
>> Frequency control values of the demodulator seems to be ok now. Also adc
>> and coeff looks correct. It is hard to say where is problem...
>> Can you test if demodulator can detect TPS parameter automatically? You
>> can do that inserting AUTO to initial tuning file, for example set FEC
>> AUTO. And then "scan tuning-file"
> 
> Sorry I'm completely lost at this point, are you talking about adding something
> to /usr/share/dvb-apps/dvb-t/au-sydney_north_shore and then running
> scandvb, or are you talking about something else?

yes, adding parameters to tuning-file. I added some AUTO parameters, use 
attached file to scan. Try "scan au-Sydney_North_Shore_test", hopefully 
it says something more that tuning failed. It is good indicator if there 
is even PID-filter timeouts.

I have no idea how to debug more. Without device it is rather hard to 
test many things. It will help a little if we know is tuner locked. 
Mike, is it easy to add debug writing for tuner to indicate if tuner is 
locked or not locked? I have used that method earlier with mt2060 tuner...

Good luck for Kimi and Heikki todays F1 Australian GP:)

regards
Antti
-- 
http://palosaari.fi/

--------------010904050205080903030705
Content-Type: text/plain;
 name="au-Sydney_North_Shore_test"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="au-Sydney_North_Shore_test"

# Australia / Sydney / North Shore (aka Artarmon/Gore Hill/Willoughby)
#
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
#
# ABC VHF12
T 226500000 7MHz 3/4 NONE QAM64 AUTO 1/16 NONE
# Seven VHF6
T 177500000 7MHz AUTO NONE QAM64 8k 1/16 NONE
# Nine VHF8
T 191625000 7MHz 3/4 NONE AUTO 8k 1/16 NONE
# Ten VHF11
T 219500000 7MHz 3/4 NONE QAM64 8k AUTO NONE
# SBS UHF34
T 571500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
# D44 UHF35
T 578500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE

--------------010904050205080903030705
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------010904050205080903030705--
