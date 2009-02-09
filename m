Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n19GxflN003260
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 11:59:41 -0500
Received: from mail-gx0-f10.google.com (mail-gx0-f10.google.com
	[209.85.217.10])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n19GxLei024363
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 11:59:21 -0500
Received: by gxk3 with SMTP id 3so1737742gxk.3
	for <video4linux-list@redhat.com>; Mon, 09 Feb 2009 08:59:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4990525D.5020205@linuxtv.org>
References: <509279.77236.qm@web31601.mail.mud.yahoo.com>
	<4990525D.5020205@linuxtv.org>
Date: Mon, 9 Feb 2009 11:59:21 -0500
Message-ID: <b24e53350902090859h6a714b2fh8cfaf8d487cecc44@mail.gmail.com>
From: Robert Krakora <rob.krakora@messagenetsystems.com>
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
>
>
>
>
> --> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>

Jon:

I too ran into this problem when purchasing what I thought was an
HVR950.  I bought several of what I thought were HVR950 and I ended up
getting both HVR950 and HVR950Q parts in the same packaging.  After
further investigation, the folks at Hauppauge explained the reason
behind packaging the HVR950Q as an HVR950.  I do not want to
miss-quote them, so please call them if you want the explanation.
They are very "up-front".  HVR950Q analog works quite well on Windows
machines though I do prefer and almost exclusively only build Linux
machines.  With all due respect to Hauppauge, KWorld makes a part call
the KWorld 330U that is basically an HVR950 with a slightly different
front end.  However, it cannot do QAM256 (Clear QAM) but it works very
well for 8VSB (ATSC) and NTSC.

New Egg has them for only $50.  Ignore the reviews, this is a good
part.  It is not listed as supported yet only because we have not
fully tested the analog video and audio inputs.  Please get the latest
V4L code from the tree at www.linuxtv.org.

http://www.newegg.com/Product/Product.aspx?Item=N82E16815260006&nm_mc=OTC-Froogle&cm_mmc=OTC-Froogle-_-Video+Devices+++TV+Tuners-_-Kworld+Computer+Co.+Ltd-_-15260006

Best Regards,

Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
