Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DNDHP5031137
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:13:17 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DNCsuk006058
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:12:55 -0500
Received: by rv-out-0910.google.com with SMTP id k15so113614rvb.51
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 15:12:53 -0800 (PST)
Date: Wed, 13 Feb 2008 14:21:19 -0800
From: Brandon Philips <brandon@ifup.org>
To: Ian.davidson@bigfoot.com
Message-ID: <20080213222119.GA16157@plankton.ifup.org>
References: <47AF671E.2030509@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AF671E.2030509@blueyonder.co.uk>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Alsa Mixer Settings
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

On 21:05 Sun 10 Feb 2008, Ian Davidson wrote:
> I am running Fedora Core 4 and I use the machine to record.  On various 
> occasions I have updated the software.  Sometimes ALSA Mixer remembers the 
> settings from one boot to another - and sometimes it forgets.  Currently, it 
> is in a 'forgetting mood' so each time I boot, the settings are the same as 
> last time I BOOTED. I change them, but when I boot again, there they are 
> back at the old settings again.  (This is not zero or maximum, but somewhere 
> in between)

Under Debian there is a script in /etc/init.d/alsa-utils that restores
the alsamixer settings on startup and saves on shutdown.  SuSE has the
same in /etc/init.d/alsasound

Likely Fedora has the same thing- only it is broken on your setup. :D 

I would report the bug to the Fedora bugzilla:
  https://bugzilla.redhat.com/index.cgi 
 
Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
