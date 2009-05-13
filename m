Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4DK8fLu013615
	for <video4linux-list@redhat.com>; Wed, 13 May 2009 16:08:41 -0400
Received: from smtp109.rog.mail.re2.yahoo.com (smtp109.rog.mail.re2.yahoo.com
	[68.142.225.207])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n4DK8OAs012528
	for <video4linux-list@redhat.com>; Wed, 13 May 2009 16:08:24 -0400
From: William Case <billlinux@rogers.com>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <1241982336.31677.0.camel@localhost.localdomain>
References: <1241982336.31677.0.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 13 May 2009 16:07:36 -0400
Message-Id: <1242245256.10294.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: Completely flummoxed -- Hauppauge WinTV-hvr-1800 PCIe won't
 work with tvtime or mplayer.
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

Hi;

On Sun, 2009-05-10 at 15:05 -0400, William Case wrote:
> Hi;
> 
> I have been trying to get my tuner card working for over a week now.
> 
> I have tried all the advice I can find on various sites as well as the
> Fedora users list.  But no joy.  It was suggested on that list that I
> try here.
> 

v4l-cx23885-avcore-01.fw
v4l-cx23885-enc.fw

have been installed in ( copied to) /lib/firmware/ as per

the 'extract.sh' file from 

http://steventoth.net/linux/hvr1800/

I have even created a /lib/firmware/2.6.27.21-170.2.56.fc10.x86_64
containing links to the /lib/firmware/ files in order to exactly follow
the extract.sh instructions.

I had installed this firmware before my original post!

> ==> Video works but no sound!
> 
> 
> ==> mplayer gives me a terrible picture and no sound.
> 
> (terrible = inverted picture with green background; just black and
> magenta for colours; and vertical lines running through it.)
> 
> I have tried the sound with PulseAudio installed and removed.  No
> difference.

Please see my previous postings below for more data.

If I am doing something stupid, please take the time to tell me.

-- 
Regards Bill
Fedora 10, Gnome 2.24.3
Evo.2.24.5, Emacs 22.3.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
