Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sun, 5 Oct 2008 12:46:03 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: =?us-ascii?Q?Niels_Wagenaar?= <n.wagenaar@xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.0810051134550.28540@shogun.pilppa.org>
Message-ID: <Pine.LNX.4.64.0810051244050.28540@shogun.pilppa.org>
References: <> <vmime.48e783ed.1f22.5c54cd2143673187@shalafi.ath.cx>
	<Pine.LNX.4.64.0810051134550.28540@shogun.pilppa.org>
MIME-Version: 1.0
Cc: "=?us-ascii?Q?LinuxTV_Mailinglist_=28linux-dvb=40linuxtv.org=29?="
	<linux-dvb@linuxtv.org>,
	"=?us-ascii?Q?VDR_Mailinglist_=28vdr=40linuxtv.org=29?=" <vdr@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] S2API for vdr-1.7.0 (04-10-2008 - quickhack
 for DVB-S(2), DVB-T and DVB-C)
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

On Sun, 5 Oct 2008, Mika Laitio wrote:

>> Hello All,
>>
>> Today I finished the patch for DVB-S, DVB-S2, DVB-T and DVB-C support using S2API
>> in combination with VDR 1.7.0.
>> I've tested my code on DVB-S, DVB-S2 and DVB-T transports and they were
>> all successful. DVB-C is untested (don't have a DVB-C option where I
>> live) but it should work in *THEORY* ;)
>>
>> DVB-S and DVB-S2 were tested on a Hauppauge WinTV-NOVA-HD-S2 card.
>> DVB-T was tested on a Gigabyte GT-U7000-RH USB device.
>> I used the latest v4l pull and viewing was very stable with both DVB
>> devices. I also didn't had any problems any more when switching between
>> DVB-S(2) and DVB-T, but it can be that this patch will *NOT* work
>> correctly on MFE DVB devices like the HVR-3000 or HVR-4000 (I had to do some hacking because strangely,
>> DVB-T transports were offered to my DVB-S DVB device). Since I can't
>> test this, I hope others can tell me if it works or not.
>>
>> Enclosed are two patches. The clean patch is for a clean VDR 1.7.0
>> source tree patched with Reinhard's
>> vdr-1.7.0-h264-syncearly-framespersec-audioindexer-fielddetection-speedup.diff.bz2
>> patch. The patched patch is for those who have used Edgar (gimli)
>> Hucek's patch for VDR 1.7.0. In theory it should also work with my last send
>> patch.
>
> Hi
>
> I tried your patch and vdr fails to show dvb-t channels for me while dvb-s
> channels works ok.
>
> I have tested with a following setup:
>
> - vdr-1.7.0
> + vdr-1.7.0-h264-syncearly-framespersec-audioindexer-fielddetection-speedup.diff
> + vdr-1.7.0-s2api-04102008-clean.patch
> - latest s2-mfe installed for 2.6.27-rc8
> - card-0: hvr-1300 (dvb-t, terrestrial cable connected)
> - card-1: hvr-4000 (dvb-t, dvb-s, dvb-s2, only satellite cable connected)
>
> [lamikr@tinka ~]$ ls -la /dev/dvb/adapter0/
> total 0
> drwxr-xr-x  2 root   root     120 2008-10-05 10:56 ./
> drwxr-xr-x  4 root   root      80 2008-10-05 10:56 ../
> crw-rw----+ 1 lamikr video 212, 4 2008-10-05 10:56 demux0
> crw-rw----+ 1 lamikr video 212, 5 2008-10-05 10:56 dvr0
> crw-rw----+ 1 lamikr video 212, 3 2008-10-05 10:56 frontend0
> crw-rw----+ 1 lamikr video 212, 7 2008-10-05 10:56 net0
> [lamikr@tinka ~]$ ls -la /dev/dvb/adapter1/
> total 0
> drwxr-xr-x  2 root   root      200 2008-10-05 10:56 ./
> drwxr-xr-x  4 root   root       80 2008-10-05 10:56 ../
> crw-rw----+ 1 lamikr video 212, 68 2008-10-05 10:56 demux0
> crw-rw----+ 1 lamikr video 212, 84 2008-10-05 10:56 demux1
> crw-rw----+ 1 lamikr video 212, 69 2008-10-05 10:56 dvr0
> crw-rw----+ 1 lamikr video 212, 85 2008-10-05 10:56 dvr1
> crw-rw----+ 1 lamikr video 212, 67 2008-10-05 10:56 frontend0
> crw-rw----+ 1 lamikr video 212, 83 2008-10-05 10:56 frontend1
> crw-rw----+ 1 lamikr video 212, 71 2008-10-05 10:56 net0
> crw-rw----+ 1 lamikr video 212, 87 2008-10-05 10:56 net1
>
> I also tried to connect the terrestrial cable to hvr-4000, but it did not
> change anything.
>
> If I use tzap, dvbstream and mplayer
> compination for hvr-1300 or if I use vdr-1.7.0 with liplianis multiptoto
> drivers, then also dvb-t channels works ok.
>
> Mika
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

And here is the output from syslog after trying to switch channel:

Oct  5 12:43:20 tinka vdr: [21353] switching to channel 1
Oct  5 12:43:21 tinka vdr: [21446] transfer thread ended (pid=21353, 
tid=21446)
Oct  5 12:43:21 tinka vdr: [21353] buffer stats: 0 (0%) used
Oct  5 12:43:21 tinka vdr: [21486] transfer thread started (pid=21353, 
tid=21486)
Oct  5 12:43:21 tinka vdr: [21448] TS buffer on device 1 thread ended 
(pid=21353, tid=21448)
Oct  5 12:43:21 tinka vdr: [21447] buffer stats: 0 (0%) used
Oct  5 12:43:21 tinka vdr: [21447] receiver on device 1 thread ended 
(pid=21353, tid=21447)
Oct  5 12:43:21 tinka vdr: [21487] receiver on device 1 thread started 
(pid=21353, tid=21487)
Oct  5 12:43:21 tinka vdr: [21488] TS buffer on device 1 thread started 
(pid=21353, tid=21488)
Oct  5 12:43:22 tinka vdr: [21357] frontend 0 timed out while tuning to 
channel 1, tp 706
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
FE_SET_PROPERTY
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
properties.num = 1
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
properties.props = 0000000042682d00
Oct  5 12:43:22 tinka kernel: dtv_property_process_set()
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.cmd    = 0x00000002 
(DTV_CLEAR)
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.u.data = 0x00000000
Oct  5 12:43:22 tinka kernel: dtv_property_process_set() Flushing property 
cache
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
FE_SET_PROPERTY
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
properties.num = 6
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
properties.props = 0000000042682d00
Oct  5 12:43:22 tinka kernel: dtv_property_process_set()
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.cmd    = 0x00000002 
(DTV_CLEAR)
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.u.data = 0x00000000
Oct  5 12:43:22 tinka kernel: dtv_property_process_set() Flushing property 
cache
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
FE_SET_PROPERTY
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
properties.num = 6
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() 
properties.props = 0000000042682d00
Oct  5 12:43:22 tinka kernel: dtv_property_process_set()
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.cmd    = 0x00000011 
(DTV_DELIVERY_SYSTEM)
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.u.data = 0x00000003
Oct  5 12:43:22 tinka kernel: dtv_property_process_set()
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.cmd    = 0x00000003 
(DTV_FREQUENCY)
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.u.data = 0x2a14b480
Oct  5 12:43:22 tinka kernel: dtv_property_process_set()
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.cmd    = 0x00000006 
(DTV_INVERSION)
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.u.data = 0x00000002
Oct  5 12:43:22 tinka kernel: dtv_property_process_set()
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.cmd    = 0x00000005 
(DTV_BANDWIDTH_HZ)
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.u.data = 0x00000000
Oct  5 12:43:22 tinka kernel: dtv_property_process_set()
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.cmd    = 0x00000004 
(DTV_MODULATION)
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.u.data = 0x00000003
Oct  5 12:43:22 tinka kernel: dtv_property_process_set()
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.cmd    = 0x00000001 
(DTV_TUNE)
Oct  5 12:43:22 tinka kernel: dtv_property_dump() tvp.u.data = 0x00000000
Oct  5 12:43:22 tinka kernel: dtv_property_process_set() Finalised 
property cache
Oct  5 12:43:22 tinka kernel: dtv_property_cache_submit()
Oct  5 12:43:22 tinka kernel: dtv_property_cache_submit() legacy, 
modulation = 3
Oct  5 12:43:22 tinka kernel: dtv_property_legacy_params_sync()
Oct  5 12:43:22 tinka kernel: dtv_property_legacy_params_sync() Preparing 
OFDM req
Oct  5 12:43:22 tinka kernel: dvb_frontend_ioctl_properties() Property 
cache is full, tuning

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
