Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33720 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab0FNVJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 17:09:45 -0400
Message-ID: <4C169AA6.6030809@gmail.com>
Date: Mon, 14 Jun 2010 14:09:58 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8]reiserfs:stree.c Fix variable set but not used.
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-2-git-send-email-justinmattock@gmail.com> <20100614204805.GA12589@elliptictech.com>
In-Reply-To: <20100614204805.GA12589@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2010 01:48 PM, Nick Bowler wrote:
> On 13:26 Mon 14 Jun     , Justin P. Mattock wrote:
>> @@ -617,8 +616,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>>
>>   	pathrelse(search_path);
>>
>> -	right_neighbor_of_leaf_node = 0;
>> -
>> +	
>
> This hunk introduces whitespace on the empty line, which is not cool.

I can resend!!(biggest problem is working
through these warnings)

>
>>   	/* With each iteration of this loop we search through the items in the
>>   	   current node, and calculate the next current node(next path element)
>>   	   for the next iteration of this loop.. */
>> @@ -695,8 +693,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>>   			   starting from the root. */
>>   			block_number = SB_ROOT_BLOCK(sb);
>>   			expected_level = -1;
>> -			right_neighbor_of_leaf_node = 0;
>> -
>> +			
>
> Here, too.
>
> Most of the patches in this series have similar issues.
>

main thing now(for me atleast)is,
is this actual dead code or what?
if not then something else needs to
be done, if yes then I guess I can
resend this, with out the whitespace
issue.

Justin P. Mattock
