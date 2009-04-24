Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3OM9Z39015173
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 18:09:35 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3OM9IAA022026
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 18:09:18 -0400
Received: by yx-out-2324.google.com with SMTP id 8so765569yxg.81
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 15:09:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090425080356.69e0ed9d.erik@bcode.com>
References: <20090424170352.313f1feb.erik@bcode.com>
	<412bdbff0904240625y3902243em5a643380b036e08f@mail.gmail.com>
	<20090425080356.69e0ed9d.erik@bcode.com>
Date: Fri, 24 Apr 2009 18:09:17 -0400
Message-ID: <412bdbff0904241509r29b0859fl22abe2fe78e59daa@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: Compling drivers from v4l-dvb hg tree
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

On Fri, Apr 24, 2009 at 6:03 PM, Erik de Castro Lopo <erik@bcode.com> wrote:
> On Fri, 24 Apr 2009 09:25:00 -0400
> Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>
>> On Fri, Apr 24, 2009 at 3:03 AM, Erik de Castro Lopo <erik@bcode.com> wrote:
>> > Hi all,
>> >
>> > What's the recommended way for compiling drivers from v4l-dvb hg tree?
>
>>
>> http://linuxtv.org/repo
>
> Ok, but how do I patch the v4l-dvb sources into a linux kernel tree?

You don't.

The v4l-dvb sources are maintained out-of-tree, and override whatever
is in the linux kernel tree.  Periodically, the v4l-dvb maintainer
syncs with the kernel tree and the changes are pushed upstream into
the mainline kernel.  This approach allows for the v4l-dvb project to
be used with kernel releases other than the current bleeding edge
kernel.

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
