Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBBK0wLo020938
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:00:58 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBBJxjOp026057
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 14:59:45 -0500
Received: by fg-out-1718.google.com with SMTP id e21so556606fga.7
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 11:59:45 -0800 (PST)
Message-ID: <412bdbff0812111159t79fd8647w6f883496350b8585@mail.gmail.com>
Date: Thu, 11 Dec 2008 14:59:44 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
In-Reply-To: <alpine.DEB.1.10.0812112053560.26420@bakacsin.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
	<alpine.DEB.1.10.0811262054050.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261226l478e3d4eg2f0551239e56540a@mail.gmail.com>
	<alpine.DEB.1.10.0811262158020.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261343m32021a70ia5a1e3541233c2bd@mail.gmail.com>
	<alpine.DEB.1.10.0811271936080.6927@bakacsin.ki.iif.hu>
	<412bdbff0812110832h1ab889b7jc30f6e84993456c4@mail.gmail.com>
	<alpine.DEB.1.10.0812112053560.26420@bakacsin.ki.iif.hu>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [video4linux] Attention em28xx users
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

On Thu, Dec 11, 2008 at 2:56 PM, Kiss Gabor (Bitman)
<kissg@ssg.ki.iif.hu> wrote:
>> Are you there?  I would really like to get this support checked in, so
>> if you could please get back to me I would appreciate it.
>
> Hi Devin,
>
> I'm just coming from my brother. On his machine we could capture
> further USB sessions with channel switch.
>
> Within a few minutes I prepare and publish the files.
>
> Cheers
>
> Gabor

Hello Gabor,

Please, do not make any channel switches.  Just start the USB capture,
plug in the device, tune to a single channel, wait two seconds, and
stop USB capture.

The problem I'm having right now is that is appears you kept switching
channels and putting multiple connects/disconnects in the same
capture.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
