Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SJAnvc024245
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 15:10:49 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6SJAUHU024054
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 15:10:30 -0400
Message-ID: <488E19A0.9090603@gmx.net>
Date: Mon, 28 Jul 2008 21:10:24 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <488B7AD1.1040106@gmx.net>
In-Reply-To: <488B7AD1.1040106@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: saa7134-alsa  appears to be broken
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

On 07/26/2008 09:28 PM, P. van Gaans wrote:
> On my Asus P7131 (DVB-T+analog+radio) I can't listen to FM radio anymore 
> with a recent v4l-dvb or multiproto. If I go back to the v4l-dvb that 
> comes with the kernel (2.6.24-19) I do get sound. Not completely without 
> problems, have to restart aplay/arecord now and then but at least it 
> works. With the recent v4l-dvb/multiproto it doesn't work at all.
> 
> dmesg has something to say (took out the interesting part):
> 
> [   31.155028] saa7133[0]: registered device video0 [v4l2]
> [   31.155043] saa7133[0]: registered device vbi0
> [   31.155055] saa7133[0]: registered device radio0
> [   31.247453] saa7134_alsa: disagrees about version of symbol 
> saa7134_tvaudio_setmute
> [   31.247457] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
> [   31.247542] saa7134_alsa: disagrees about version of symbol 
> saa_dsp_writel
> [   31.247544] saa7134_alsa: Unknown symbol saa_dsp_writel
> [   31.247808] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_init
> [   31.247809] saa7134_alsa: Unknown symbol saa7134_dmasound_init
> [   31.247884] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_exit
> [   31.247886] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
> [   31.248165] saa7134_alsa: disagrees about version of symbol 
> saa7134_set_dmabits
> [   31.248167] saa7134_alsa: Unknown symbol saa7134_set_dmabits
> [   31.320315] DVB: registering new adapter (saa7133[0])
> 
> I don't know if this also causes my problem but it possibly does. The 
> saa7134 audio device is not recognized at all.
> 
> And yes, I have the firmware (required for DVB-T so irrelevant but 
> anyway) installed.
> 
> -- 
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

Ok, so I've probably done something wrong since there's no reply (and 
saa7134-alsa isn't that rare). If anyone would mind to tell me what it 
is so I can tell you and hopefully this bug can be fixed..

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
