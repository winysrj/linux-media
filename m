Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01HZgwf025595
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 12:35:42 -0500
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01HZOxG001992
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 12:35:25 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Hobson <linux@thehobsons.co.uk>
In-Reply-To: <a0624080fc5829ec402a2@simon.thehobsons.co.uk>
References: <a06240804c580f44d7a48@simon.thehobsons.co.uk>
	<a0624080bc58126e6561c@simon.thehobsons.co.uk>
	<1230824289.2669.2.camel@pc10.localdom.local>
	<a0624080fc5829ec402a2@simon.thehobsons.co.uk>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 18:35:50 +0100
Message-Id: <1230831350.7045.15.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Problem setting up HVR-1110
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Am Donnerstag, den 01.01.2009, 16:30 +0000 schrieb Simon Hobson:
> hermann pitton wrote:
> 
> >yep, 2.6.18 was too old.
> 
> Hmm, I'd been going from the Wiki that suggested it was supported in 
> 2.6.18. From http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards :
> 
> >>Supported with the latest 2.6.18 kernel
> 
> Anyway, forced me to upgrade a few things AND learn some more about 
> fixing stuff I broke !
> 
> Mind you, it took some time to figure out why I couldn't find any 
> channels. Borrowed the portable telly from another room to check the 
> aerial and found ... that I'd got a wonky plug and the pin was pushed 
> over and shorting out. Works a lot better with a signal :-/
> 

2.6.18 does not have it at all and ends here.

#define SAA7134_BOARD_KWORLD_ATSC110   90
#define SAA7134_BOARD_AVERMEDIA_A169_B 91
#define SAA7134_BOARD_AVERMEDIA_A169_B1 92
#define SAA7134_BOARD_MD7134_BRIDGE_2     93
#define SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS 94
#define SAA7134_BOARD_FLYVIDEO3000_NTSC 95

We are now there including card=104.

#define SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS 94
#define SAA7134_BOARD_FLYVIDEO3000_NTSC 95
#define SAA7134_BOARD_MEDION_MD8800_QUADRO 96
#define SAA7134_BOARD_FLYDVBS_LR300 97
#define SAA7134_BOARD_PROTEUS_2309 98
#define SAA7134_BOARD_AVERMEDIA_A16AR   99
#define SAA7134_BOARD_ASUS_EUROPA2_HYBRID 100
#define SAA7134_BOARD_PINNACLE_PCTV_310i  101
#define SAA7134_BOARD_AVERMEDIA_STUDIO_507 102
#define SAA7134_BOARD_VIDEOMATE_DVBT_200A  103
#define SAA7134_BOARD_HAUPPAUGE_HVR1110    104
#define SAA7134_BOARD_CINERGY_HT_PCMCIA    105
#define SAA7134_BOARD_ENCORE_ENLTV         106
#define SAA7134_BOARD_ENCORE_ENLTV_FM      107
#define SAA7134_BOARD_CINERGY_HT_PCI       108
#define SAA7134_BOARD_PHILIPS_TIGER_S      109
#define SAA7134_BOARD_AVERMEDIA_M102	   110
#define SAA7134_BOARD_ASUS_P7131_4871	   111
#define SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA 112
#define SAA7134_BOARD_ECS_TVP3XP_4CB6  113
#define SAA7134_BOARD_KWORLD_DVBT_210 114
#define SAA7134_BOARD_SABRENT_TV_PCB05     115
#define SAA7134_BOARD_10MOONSTVMASTER3     116
#define SAA7134_BOARD_AVERMEDIA_SUPER_007  117
#define SAA7134_BOARD_BEHOLD_401  	118
#define SAA7134_BOARD_BEHOLD_403  	119
#define SAA7134_BOARD_BEHOLD_403FM	120
#define SAA7134_BOARD_BEHOLD_405	121
#define SAA7134_BOARD_BEHOLD_405FM	122
#define SAA7134_BOARD_BEHOLD_407	123
#define SAA7134_BOARD_BEHOLD_407FM	124
#define SAA7134_BOARD_BEHOLD_409	125
#define SAA7134_BOARD_BEHOLD_505FM	126
#define SAA7134_BOARD_BEHOLD_507_9FM	127
#define SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM 128
#define SAA7134_BOARD_BEHOLD_607_9FM	129
#define SAA7134_BOARD_BEHOLD_M6		130
#define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
#define SAA7134_BOARD_GENIUS_TVGO_A11MCE   132
#define SAA7134_BOARD_PHILIPS_SNAKE        133
#define SAA7134_BOARD_CREATIX_CTX953       134
#define SAA7134_BOARD_MSI_TVANYWHERE_AD11  135
#define SAA7134_BOARD_AVERMEDIA_CARDBUS_506 136
#define SAA7134_BOARD_AVERMEDIA_A16D       137
#define SAA7134_BOARD_AVERMEDIA_M115       138
#define SAA7134_BOARD_VIDEOMATE_T750       139
#define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
#define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
#define SAA7134_BOARD_BEHOLD_H6      142
#define SAA7134_BOARD_BEHOLD_M63      143
#define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
#define SAA7134_BOARD_AVERMEDIA_M103    145
#define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 146
#define SAA7134_BOARD_ASUSTeK_TIGER_3IN1   147
#define SAA7134_BOARD_ENCORE_ENLTV_FM53 148
#define SAA7134_BOARD_AVERMEDIA_M135A    149
#define SAA7134_BOARD_REAL_ANGEL_220     150
#define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  151
#define SAA7134_BOARD_ASUSTeK_TIGER         152
#define SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG 153



Also Michael added a bunch of them even later including yours.

		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
		.subvendor    = 0x0070,
		.subdevice    = 0x6700,
		.driver_data  = SAA7134_BOARD_HAUPPAUGE_HVR1110,
	},{
		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
		.subvendor    = 0x0070,
		.subdevice    = 0x6701,
		.driver_data  = SAA7134_BOARD_HAUPPAUGE_HVR1110,
	},{
		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
		.subvendor    = 0x0070,
		.subdevice    = 0x6702,
		.driver_data  = SAA7134_BOARD_HAUPPAUGE_HVR1110,
	},{
		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
		.subvendor    = 0x0070,
		.subdevice    = 0x6703,
		.driver_data  = SAA7134_BOARD_HAUPPAUGE_HVR1110,
	},{
		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
		.subvendor    = 0x0070,
		.subdevice    = 0x6704,
		.driver_data  = SAA7134_BOARD_HAUPPAUGE_HVR1110,
	},{
		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
		.subvendor    = 0x0070,
		.subdevice    = 0x6705,
		.driver_data  = SAA7134_BOARD_HAUPPAUGE_HVR1110,
	},{

And that's why you had UNKNOWN/GENERIC detected.

What I get in dmesg is :

>saa7130/34: v4l2 driver version 0.2.14 loaded
>PCI: Enabling device 0000:00:00.0 (0000 -> 0002)
>saa7133[0]: found at 0000:00:00.0, rev: 209, irq: 17, latency: 32, 
>mmio: 0xf4100000
>saa7133[0]: subsystem: 0070:6701, board: UNKNOWN/GENERIC
[card=0,autodetected]
>saa7133[0]: board init: gpio is 6400000

Also LNA activation for analog was missing.

http://linuxtv.org/hg/v4l-dvb/rev/b227949c41ad

Yesterday I could not believe that /me should have hardware hitting all
major bugs in Fedora 10, some known since FC6 and even improved now.

Now I do ...

If in doubt, always trust the code :)

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
