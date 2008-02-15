Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FJir81021585
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 14:44:53 -0500
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FJiKUV002157
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 14:44:20 -0500
Message-ID: <47B5EB9C.9010106@free.fr>
Date: Fri, 15 Feb 2008 20:44:28 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <1202915751-9326-1-git-send-email-jirislaby@gmail.com>	<1202915751-9326-4-git-send-email-jirislaby@gmail.com>
	<47B5D754.4070103@free.fr>
In-Reply-To: <47B5D754.4070103@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jiri Slaby <jirislaby@gmail.com>, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: [PATCH 4/4] v4l2_extension: grab real driver reference
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

Thierry Merle a écrit :
> Jiri Slaby a écrit :
>   
>> From: Jiri Slaby <ku@bellona.localdomain>
>>
>> Before opening real backing device, make sure, it is there and not going away.
>> Drop the reference after release and failing open.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> ---
>>     
> All this patch series is comitted in
> http://linuxtv.org/hg/~tmerle/v4l2_extension , thanks.
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>   
Argh, I did not notice, this patch series is for the v4l2 library, not
for the v4l-dvb mainstream.
Sorry people, wrong list :)
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
