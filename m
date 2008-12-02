Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB280aI8018260
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 03:00:36 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB280EUL030556
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 03:00:14 -0500
Received: by qb-out-0506.google.com with SMTP id c8so2952736qbc.7
	for <video4linux-list@redhat.com>; Tue, 02 Dec 2008 00:00:14 -0800 (PST)
Message-ID: <5d5443650812020000t3ed04d1am4963b9fe914d34a0@mail.gmail.com>
Date: Tue, 2 Dec 2008 13:30:13 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <5d5443650812012228u5aad36a2jc3e9e68cd61c27e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812011451.06156.hverkuil@xs4all.nl>
	<5d5443650812011014q55a96540gc8a4b97be951f2fd@mail.gmail.com>
	<20081201202209.5cea1f4b@pedra.chehab.org>
	<5d5443650812012228u5aad36a2jc3e9e68cd61c27e3@mail.gmail.com>
Cc: v4l <video4linux-list@redhat.com>, Sakari Ailus <sakari.ailus@nokia.com>,
	linux-kernel@vger.kernel.org,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
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

Hi,

On Tue, Dec 2, 2008 at 11:58 AM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Mauro,
>
>>
>> This is one of the lack of the features on mercurial. It doesn't have a meta
>> tag for committer. On mercurial, the -hg user and the author should be the same
>> person.
>>
>> Since we want to identify the patch origin (e.g. whose v4l/dvb maintainer got
>> the patch), we use the internal "user" meta-tag as the committer, and an extra
>> tag, at the patch description for the author (From:).
>>
>> When creating the -git patch, the "From:" tag is replaced, by script, for
>> "Author:", I add my SOB there, and, I add myself as the -git committer (on git
>> we have both meta-tags).
>
> Isn't it good time to move v4l2-dvb tree to GIT? I am not aware of any
> hg-to-git repo. converter, but I can check with hg and git community.
> It could be difficult at first, but I am very confident that there are
> many GIT users here than mercurial, and yes your v4l-dvb maintenance
> process might change due move from GIT, but atleast you will not have
> to internal user meta-data per patch.

OK, there are tools to convert mercurial to git repo.

http://git.or.cz/gitwiki/InterfacesFrontendsAndTools#head-8870e1c81cc93f9a7a7acb5e969924ee60182d6b
http://hedonismbot.wordpress.com/2008/10/16/hg-fast-export-convert-mercurial-repositories-to-git-repositories/


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
