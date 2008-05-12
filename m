Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sd-green-bigip-207.dreamhost.com ([208.97.132.207]
	helo=spunkymail-a18.g.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@dawes.za.net>) id 1JvZQF-0008FO-4Q
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 16:54:40 +0200
Message-ID: <482859DC.6060800@dawes.za.net>
Date: Mon, 12 May 2008 16:53:16 +0200
From: Rogan Dawes <lists@dawes.za.net>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
References: <48281E7A.8010006@dawes.za.net>
	<Pine.LNX.4.64.0805121254410.11078@pub3.ifh.de>
	<48282843.6010906@dawes.za.net>
	<Pine.LNX.4.64.0805121418530.11078@pub3.ifh.de>
	<48283D17.3060303@dawes.za.net> <48284D8B.4050909@dawes.za.net>
	<Pine.LNX.4.64.0805121604170.11078@pub3.ifh.de>
In-Reply-To: <Pine.LNX.4.64.0805121604170.11078@pub3.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T South Africa
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

Patrick Boettcher wrote:
> Hi again,
> On Mon, 12 May 2008, Rogan Dawes wrote:
>> I guess this is related to a weak/corrupted signal, although the ber 
>> showing up while running tzap seemed reasonable:
> 
> A reasonable BER is 0 and (if the demod-driver is supporting) UNC should 
> be 0 as well.
> 
> BER is the bit-error-rate, not the bitrate.
> 
>> I guess I'll need to get a better DVB antenna.
> 
> Try to open the window or to put the antenna outside, rotate the 
> antenna, check the cables and connector, while having femon running and 
> check which position is the best.
> 
> Sometimes it helps,
> Patrick.
> 

Ok, so I tried unplugging and replugging the antenna, just to make sure 
that femon would pick up the crudest of changes, before I tried more 
refined ones.

I got the following, but it also crashed my machine :-(

rogan@athena:~$ tzap "eTV(ETV)" > /dev/null &
[1] 5339
rogan@athena:~$ femon
using '/dev/dvb/adapter0/frontend0'
FE: Philips TDA10046H DVB-T (TERRESTRIAL)
status 00 | signal 8b8b | snr 3030 | ber 0001fffe | unc ffffffff |
status 1f | signal 8989 | snr f6f6 | ber 0001a268 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 8989 | snr 6565 | ber 0001fffe | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 8989 | snr f6f6 | ber 0001b110 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 8989 | snr ecec | ber 0001ac00 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 8888 | snr f4f4 | ber 0001a84c | unc ffffffff | 
FE_HAS_LOCK
status 01 | signal 8989 | snr 6161 | ber 0001fffe | unc ffffffff |
status 1f | signal 8888 | snr f2f2 | ber 0001b28c | unc ffffffff | 
FE_HAS_LOCK
status 00 | signal 8989 | snr 2c2c | ber 0001fffe | unc ffffffff |
status 1f | signal 8989 | snr f3f3 | ber 0001a590 | unc ffffffff | 
FE_HAS_LOCK
status 00 | signal 8787 | snr 6d6d | ber 0001fffe | unc ffffffff |
status 1f | signal 8888 | snr f4f4 | ber 0001aeae | unc ffffffff | 
FE_HAS_LOCK
status 01 | signal 8989 | snr 8f8f | ber 0001fffe | unc ffffffff |
status 1f | signal 8787 | snr f3f3 | ber 0001e982 | unc ffffffff | 
FE_HAS_LOCK
status 00 | signal 8d8d | snr 7171 | ber 0001fffe | unc 00000001 |
status 1f | signal 8c8c | snr f5f5 | ber 00014628 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 8c8c | snr f8f8 | ber 00016fb0 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 8b8b | snr f7f7 | ber 00013b8c | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 8b8b | snr f7f7 | ber 000129d4 | unc 0000001e | 
FE_HAS_LOCK
status 1f | signal 8888 | snr f6f6 | ber 00017330 | unc ffffffff | 
FE_HAS_LOCK
status 00 | signal 0000 | snr e0e0 | ber 0001fffe | unc 00000000 |
status 00 | signal 0000 | snr 3535 | ber 0001fffe | unc 00000000 |
status 00 | signal 0000 | snr 2c2c | ber 0001fffe | unc 00000000 |
status 00 | signal 0000 | snr 3030 | ber 0001fffe | unc 00000000 |
status 00 | signal 0000 | snr e1e1 | ber 0001fffe | unc 00000000 |
status 00 | signal 0000 | snr ffff | ber 0001fffe | unc 00000000 |
status 00 | signal 0000 | snr 3737 | ber 0001fffe | unc 00000000 |
status 00 | signal 0000 | snr 7d7d | ber 0001fffe | unc 00000000 |
status 00 | signal 0000 | snr a9a9 | ber 0001fffe | unc 00000000 |

This would seem to support the notion that I am not getting a good 
enough signal, right?

Rogan


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
