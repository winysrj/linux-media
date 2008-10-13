Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DK8pDl003072
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 16:08:51 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DK8dOr028958
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 16:08:39 -0400
Message-ID: <48F3AAC7.7050402@free.fr>
Date: Mon, 13 Oct 2008 22:08:39 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: "Shah, Hardik" <hardik.shah@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D61A0CC2@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02D61A0CC2@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: Cloning the V4L2 branch
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

Hello,

Shah, Hardik a écrit :
> Sorry forgot to mention the error,
> Error coming is 
> 
> Initialize master/.git
> Initialized empty Git repository in /db/psp_git/users/a0393759/master/.git/
> warning: remote HEAD refers to nonexistent ref, unable to checkout.
> 
Right, I have the same error with git-1.6.0.2 (please upgrade your git version):
git clone http://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git 
Initialized empty Git repository in /home/tmerle/v4l-dvb/.git/
fatal: http://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git/info/refs not found: did you run git update-server-info on the server?

The little I know from git is that at least this directory:
http://www.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git/objects/pack/
should not be empty on the server...

Cheers,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
