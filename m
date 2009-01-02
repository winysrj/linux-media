Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n02E95vb025072
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 09:09:05 -0500
Received: from smtp118.rog.mail.re2.yahoo.com (smtp118.rog.mail.re2.yahoo.com
	[68.142.225.234])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n02E80SM008200
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 09:08:00 -0500
Message-ID: <495E1FBF.1090606@rogers.com>
Date: Fri, 02 Jan 2009 09:07:59 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Paul Thomas <pthomas8589@gmail.com>
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>	<412bdbff0812311323rd83eac8l35f29195b599d3e@mail.gmail.com>	<c785bba30812311330w26ce5817l10db52d5be98d175@mail.gmail.com>	<412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>	<c785bba30812311424r87bd070v9a01828c77d6a2a6@mail.gmail.com>	<412bdbff0812311435n429787ecmbcab8de00ba05b6b@mail.gmail.com>	<c785bba30812311444l65b3825aq844b79dd6f420c09@mail.gmail.com>	<412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>	<c785bba30812311504g22d2a06dkd4b1a7dc9a5b2df1@mail.gmail.com>	<c785bba30901010845if28f369n7a9c501e34b2efa8@mail.gmail.com>
	<c785bba30901011638q4b1f0b92y6898672f0cb8efb0@mail.gmail.com>
In-Reply-To: <c785bba30901011638q4b1f0b92y6898672f0cb8efb0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: em28xx issues
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

Paul Thomas wrote:
> Any thoughts on the debug parameter? Do I set the debug level a different way?
>
> thanks,
> Paul
>
> On Thu, Jan 1, 2009 at 9:45 AM, Paul Thomas <pthomas8589@gmail.com> wrote:
>   
>> I get "em28xx: Unknown parameter `debug'" when I try "modprobe em28xx debug=1".
>>
>> thanks,
>> Paul

Use /sbin/modinfo to see relevant parameters for a module.  You'll
likely want core_debug

Also please stop top posting (rather, post below the text that you are
quoting).  Thanks

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
