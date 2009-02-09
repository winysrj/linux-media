Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n19G6IPg030386
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 11:06:18 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n19G60uC019609
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 11:06:00 -0500
Received: by yw-out-2324.google.com with SMTP id 9so368791ywe.81
	for <video4linux-list@redhat.com>; Mon, 09 Feb 2009 08:06:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4990525D.5020205@linuxtv.org>
References: <509279.77236.qm@web31601.mail.mud.yahoo.com>
	<4990525D.5020205@linuxtv.org>
Date: Mon, 9 Feb 2009 11:06:00 -0500
Message-ID: <412bdbff0902090806o7e0493avaa125876837a6804@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: HVR-950Q status
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

On Mon, Feb 9, 2009 at 10:57 AM, Steven Toth <stoth@linuxtv.org> wrote:
>
>> This is where the fun ended.  I banged my head on VLC, MythTV, me-tv,
>> tvtime, vdr and others to no avail.  A little digging in the lists seemed to
>> suggest I might be able to bring in over the air stations.  But my hope is
>> to bring in analog NTSC cable channels and (gasp), possibly even Clear QAM
>> HD channels.  Is there any hope or current effort to get analog NTSC working
>> on this dongle?  Also, are there any USB dongles which support HD Clear QAM?
>>  While I am primarily interested in analog NTSC (yeah, I hear ya, shoulda
>> bought an HVR-950), getting analog and Clear QAM HD would be great.  While I
>> would love to get my HVR-950Q working, I would settle for another well
>> supported USB dongle with at least analog cable support that in known to
>> work well with MythTV.
>>
>> Thanks in advance for any feedback you can provide.
>>
>> Regards,
>> Jon
>
> NTSC is not supported.
>
> The 950Q works well with MythTV for ATSC and ClearQAM. I suggest you google
> or read the wikis at linuxtv.org. You might also want to check on linux
> support for any new product before purchasing and 'banging your head'.
>
> - Steve

To expand on Steven's comments, the following page has the list of
supported USB devices:

http://linuxtv.org/wiki/index.php/ATSC_USB_Devices#Supported_ATSC_USB_Devices

Pay particular attention to the entries with footnote #1, which are
devices such as the 950Q where the hardware supports analog but the
driver does not.  This is actually a pretty common problem with the
newer class of devices that support ClearQAM.

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
