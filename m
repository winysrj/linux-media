Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0R7Rrif020063
	for <video4linux-list@redhat.com>; Tue, 27 Jan 2009 02:27:53 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0R7RZWl003771
	for <video4linux-list@redhat.com>; Tue, 27 Jan 2009 02:27:35 -0500
Received: by rv-out-0506.google.com with SMTP id f6so6830719rvb.51
	for <video4linux-list@redhat.com>; Mon, 26 Jan 2009 23:27:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E003FCE0634F4C398AA9CC6EB8BC10E8@pcumans>
References: <E003FCE0634F4C398AA9CC6EB8BC10E8@pcumans>
Date: Tue, 27 Jan 2009 01:27:34 -0600
Message-ID: <59dfca000901262327h65ee84cdnd2aed358cbd6b154@mail.gmail.com>
From: Lucas <jaffa225man@gmail.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: ASUS My Cinema-P7131 PCI TV card produces distorded sound.
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

Try using your alsa device with the plughw plugin (such as
"plughw:0,0" for the first soundcard).  The device you specify (as
"0,0" or whatever) should be your soundcard not the My Cinema-P7131.
I'm not sure what options mythtv gives you, but I would think that it
has a place for you to specify your sound device, either through the
GUI or by editing a file.  The alsa Plughw plugin should samplerate
conversion automatically.


I hope that helps,

  Lucas


On Mon, Jan 26, 2009 at 3:57 PM, Erik Umans <Erik.Umans@skynet.be> wrote:
> Hi,
>
> I have an ASUS My Cinema-P7131 PCI TV card in my Mythtv system.
>
> I can get picture but only heavily distorded sound due to sample rate
> mismatch.
> The P7131 produces sound at 32KHz sample rate, the remaining of the system
> 48KHz.
>
> How can I fix this mismatch ?
> Can this be solved with ALSA and if so, how?
>
> Kind regards.
>
> Erik Umans
> Belgium
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
Protect your digital freedom and privacy, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
On a related note, also see BadVista.org: Stopping Vista adoption by
promoting free software

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
