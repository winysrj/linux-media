Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:58464 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752669AbcKYHjV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 02:39:21 -0500
Subject: Re: [PATCH 1/1] media: Drop FSF's postal address from the source code
 files
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
References: <1477658633-2536-1-git-send-email-sakari.ailus@linux.intel.com>
 <13836325.hF0BpjAJel@avalon>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <5837E9EE.1080401@linux.intel.com>
Date: Fri, 25 Nov 2016 09:36:14 +0200
MIME-Version: 1.0
In-Reply-To: <13836325.hF0BpjAJel@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/25/16 04:03, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday 28 Oct 2016 15:43:53 Sakari Ailus wrote:
>> Drop the FSF's postal address from the source code files that typically
>> contain mostly the license text. The patch has been created with the
>> following command without manual edits:
>>
>> git grep -l "675 Mass Ave\|59 Temple Place\|51 Franklin St" -- \
>> 	drivers/media/ include/media|while read i; do i=$i perl -e '
>> open(F,"< $ENV{i}");
>> $a=join("", <F>);
>> $a =~ s/[ \t]*\*\n.*You should.*\n.*along with.*\n.*(\n.*USA.*$)?\n//m
>> 	&& $a =~ s/(^.*)Or, (point your browser to) /$1To obtain the license,
>> $2\n$1/m; close(F);
> 
> Do we really need to keep the "To obtain the license, point your browser 
> to..." text ?

In order not to change the existing text unnecessarily, I did that in
the patch. I'm certainly ok with dropping it as it does not seemingly
really has no value.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
