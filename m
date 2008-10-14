Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ECFdMT011645
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:15:39 -0400
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ECF1jH019245
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:15:23 -0400
Received: by ik-out-1112.google.com with SMTP id c29so1616596ika.3
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 05:15:01 -0700 (PDT)
Message-ID: <30353c3d0810140515i10bba955w847af1058071b1d@mail.gmail.com>
Date: Tue, 14 Oct 2008 08:15:01 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Thierry Merle" <thierry.merle@free.fr>
In-Reply-To: <48F3AAC7.7050402@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D61A0CC2@dbde02.ent.ti.com>
	<48F3AAC7.7050402@free.fr>
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Mon, Oct 13, 2008 at 4:08 PM, Thierry Merle <thierry.merle@free.fr> wrote:
> Hello,
>
> Shah, Hardik a écrit :
>> Sorry forgot to mention the error,
>> Error coming is
>>
>> Initialize master/.git
>> Initialized empty Git repository in /db/psp_git/users/a0393759/master/.git/
>> warning: remote HEAD refers to nonexistent ref, unable to checkout.
>>
> Right, I have the same error with git-1.6.0.2 (please upgrade your git version):
> git clone http://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
> Initialized empty Git repository in /home/tmerle/v4l-dvb/.git/
> fatal: http://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git/info/refs not found: did you run git update-server-info on the server?
>
> The little I know from git is that at least this directory:
> http://www.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git/objects/pack/
> should not be empty on the server...
>
> Cheers,
> Thierry
>

Use "git clone git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git"
but note that this repository doesn't contain all of the latest
patches.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
