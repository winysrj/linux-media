Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OLTTGU017028
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 17:29:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OLTICT027067
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 17:29:18 -0400
Date: Thu, 24 Apr 2008 18:29:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080424182902.7cb8ef98@gaivota>
In-Reply-To: <20080424152813.40aab7c4@gaivota>
References: <20080424152813.40aab7c4@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [RFC] Move hybrid tuners to common/tuners
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

On Thu, 24 Apr 2008 15:28:13 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> During 2.6.24 and 2.6.25 cycle, it were noticed several issues on building
> tuner drivers, after the hybrid patches. Mostly, this happened due to the fact
> that now, those tuners are shared between DVB and V4L.
> 
> The proper solution were to move those tuners into common/tuners.
> 
> I finally found some time for a patch for it.
> 
> Since this kind of patch requires build testing with the in-kernel tree, I've
> preferred to develop this one directly at -git. It is at [1]:
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commit;h=b251551263a57d8ca518a21008f20dff29964cb9

Michael Krufky asked me to rename tda18271-tables.c to tda18271-maps.c. Due to
that, the MD5 sum changed.
Also, I've added some newer patches. One of them is reorganizing DVB frontends.
The other moves some other tuners that are also capable of working with both
analog and digital terrestrial.

Those are the current changesets:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commit;h=a97e59842748536bd8e0f159591daa0deb3f01ae
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commit;h=47838c0da0a581aa8b4223f044988de56d45f715
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commit;h=3dcb518cc91ecc49551240fde5d975e733909cc7

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
