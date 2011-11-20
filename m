Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34700 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1KTR0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 12:26:19 -0500
Received: by bke11 with SMTP id 11so5555380bke.19
        for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 09:26:18 -0800 (PST)
Message-ID: <4EC93835.7010200@gmail.com>
Date: Sun, 20 Nov 2011 18:26:13 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>
Subject: Re: [PATCH resent] Fix logic in sanity check
References: <4E99FD60.5090606@intra2net.com> <4EB3AD88.1090702@samsung.com>
In-Reply-To: <4EB3AD88.1090702@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/04/2011 10:16 AM, Sylwester Nawrocki wrote:
> On 10/15/2011 11:38 PM, Thomas Jarosch wrote:
>> Detected by "cppcheck".
>>
>> This time with "Signed-off-by" line.

When a note like this is added, not suitable for the changelog,
it should be placed after your SOB line, and below a line containing
only the "---" marker. Please check with Documentation/SubmittingPatches
for more details.

>>
>> Signed-off-by: Thomas Jarosch<thomas.jarosch@intra2net.com>
> 
> Acked-by: Sylwester Nawrocki<s.nawrocki@samsung.com>

Sorry, I was a bit too quick with this ack.


If you care to resend the patch, please add "m5mols:" as a subsystem name 
in the subject so it looks something like:

[PATCH ...] m5mols: Fix ... 

> 
>> ---
>>   drivers/media/video/m5mols/m5mols_core.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)

--
Thanks,
Sylwester
