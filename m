Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sun, 5 Oct 2008 14:41:36 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: VDR Mailing List <vdr@linuxtv.org>
In-Reply-To: <20081005145219.79a89a5c@bk.ru>
Message-ID: <Pine.LNX.4.64.0810051425330.28540@shogun.pilppa.org>
References: <vmime.48e89669.1f22.634e7ad135612f57@shalafi.ath.cx>
	<48E89837.6000102@cadsoft.de> <20081005145219.79a89a5c@bk.ru>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [vdr] [PATCH] S2API for vdr-1.7.0 (05-10-2008 -
 quickhack for DVB-S(2), DVB-T and DVB-C)
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

>>> Enclosed are two patches. The clean patch is for a clean VDR 1.7.0 source tree patched with Reinhard's
>>> vdr-1.7.0-h264-syncearly-framespersec-audioindexer-fielddetection-speedup.diff.bz2 patch. The patched patch is for
>>> those who have used the patch from 04-10-2008.
>>
>> I'm about to begin setting up my new VDR with DVB-S2 support, so I was wondering
>>
>> - where is the ultimate S2API driver source?
>
> http://linuxtv.org/hg/v4l-dvb/
> http://linuxtv.org/hg/~stoth/s2/
> http://linuxtv.org/hg/~stoth/s2-mfe/ - s2api with multifrontend support

Steve can you comment the differences between s2 and s2-mfe trees and 
whether those are planned to be compined in near future?

To my understanding the only difference between s2 and s2-mfe branches 
is the support for hvr-4000 style of devices. So:

- s2:
 	--> would support only 1 frontend for 1 card at a time. Therefore 
one would need to select during the driver loading time whether to want to use 
hvr-4000 in DVB-S/S2 mode or in DVB-T mode.

So in dev-tree following are available:

[root@tinka vdr-1.7.0]# ls -la /dev/dvb/adapter0/
total 0
drwxr-xr-x  2 root   root     120 2008-10-05 10:56 ./
drwxr-xr-x  4 root   root      80 2008-10-05 10:56 ../
crw-rw----+ 1 lamikr video 212, 4 2008-10-05 10:56 demux0
crw-rw----+ 1 lamikr video 212, 5 2008-10-05 10:56 dvr0
crw-rw----+ 1 lamikr video 212, 3 2008-10-05 10:56 frontend0
crw-rw----+ 1 lamikr video 212, 7 2008-10-05 10:56 net0

- s2-mfe:
 	--> can create multiple fronends for single card eventhoughg only 
one of those can in reality to be used simultaneously. Thus one 
does not need to select between DVB-S/S2 mode and DVB-T mode 
during the driver load time. So following nodes are available:

[root@tinka vdr-1.7.0]# ls -la /dev/dvb/adapter0/
total 0
drwxr-xr-x  2 root   root      200 2008-10-05 10:56 ./
drwxr-xr-x  4 root   root       80 2008-10-05 10:56 ../
crw-rw----+ 1 lamikr video 212, 68 2008-10-05 10:56 demux0
crw-rw----+ 1 lamikr video 212, 84 2008-10-05 10:56 demux1
crw-rw----+ 1 lamikr video 212, 69 2008-10-05 10:56 dvr0
crw-rw----+ 1 lamikr video 212, 85 2008-10-05 10:56 dvr1
crw-rw----+ 1 lamikr video 212, 67 2008-10-05 10:56 frontend0
crw-rw----+ 1 lamikr video 212, 83 2008-10-05 10:56 frontend1
crw-rw----+ 1 lamikr video 212, 71 2008-10-05 10:56 net0
crw-rw----+ 1 lamikr video 212, 87 2008-10-05 10:56 net1

Mika

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
