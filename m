Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m66E5meN029260
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 10:05:48 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m66E5Huc025458
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 10:05:17 -0400
Message-ID: <4870D2A5.4050703@hhs.nl>
Date: Sun, 06 Jul 2008 16:11:49 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
References: <48706115.5050707@hhs.nl> <4870B694.5010101@free.fr>
In-Reply-To: <4870B694.5010101@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: PATCH: libv4l-sync-with-0.3.3-release.patch
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

Thierry Merle wrote:
> Hans de Goede a écrit :
>> Hi,
>>
>> This patch syncs mercurial with the 0.3.3 tarbal I've just released.
>> note, please "hg add" all the files under appl-patches, you forgot this
>> the last time, so these files are not in mercurial yet.
>>
>> Let me know if you want this split up in 3 or 4 incremental patches.
>>
> I would prefer next time since this would help to avoid forgotten things like the appl-patches/ directory.
> I checked with your own 0.3.2 archive but found no difference so I stated my imports OK. 
> 
> Do you send these patches to the application maintainers?

Once libv4l has proven itself the vlc patch will be sent to vlc (its libvlc 
specific), as for the other 2 patches, there upstreams are very much dead I'm 
afraid.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
