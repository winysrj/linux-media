Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46874 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3AAOfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 09:35:03 -0500
Date: Tue, 1 Jan 2013 15:34:56 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] rc-core: add separate defines for protocol bitmaps and
 numbers
Message-ID: <20130101143456.GA16383@hardeman.nu>
References: <20121011231154.22683.2502.stgit@zeus.hardeman.nu>
 <CAAG0J9_iK09DCTny=6nT7u1Hrf+jMfoJMsmJmiRiwkXdQvYBsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAG0J9_iK09DCTny=6nT7u1Hrf+jMfoJMsmJmiRiwkXdQvYBsw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 17, 2012 at 03:15:27PM +0000, James Hogan wrote:
>On 12 October 2012 00:11, David Härdeman <david@hardeman.nu> wrote:
>> The RC_TYPE_* defines are currently used both where a single protocol is
>> expected and where a bitmap of protocols is expected. This patch tries
>> to separate the two in preparation for the following patches.
>>
>> The intended use is also clearer to anyone reading the code. Where a
>> single protocol is expected, enum rc_type is used, where one or more
>> protocol(s) are expected, something like u64 is used.
>>
>> The patch has been rewritten so that the format of the sysfs "protocols"
>> file is no longer altered (at the loss of some detail). The file itself
>> should probably be deprecated in the future though.
>>
>> I missed some drivers when creating the last version of the patch because
>> some weren't enabled in my .config. This patch passes an allmodyes build.
>>
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>> ---
>
>> @@ -38,7 +70,7 @@ struct rc_map {
>>         unsigned int            size;   /* Max number of entries */
>>         unsigned int            len;    /* Used number of entries */
>>         unsigned int            alloc;  /* Size of *scan in bytes */
>> -       u64                     rc_type;
>> +       enum rc_type            rc_type;
>>         const char              *name;
>>         spinlock_t              lock;
>>  };
>
>But store_protocols() sets dev->rc_map.rc_type to a bitmap. Am I
>missing something?

That was fixed in later patches (by introducing a u64 enabled_protocols
member to struct rc_dev which is used by store_protocols() and
show_protocols()).

I'll split that part out to a separate patch and submit.

-- 
David Härdeman
