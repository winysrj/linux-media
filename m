Return-path: <linux-media-owner@vger.kernel.org>
Received: from alln-iport-1.cisco.com ([173.37.142.88]:13434 "EHLO
	alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbbFUNud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 09:50:33 -0400
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 2/2] v4l2-utils: extend set-dv-timing options for RB
 version
Date: Sun, 21 Jun 2015 13:50:32 +0000
Message-ID: <D1ACBC8C.4E61D%prladdha@cisco.com>
References: <1434447031-21434-1-git-send-email-prladdha@cisco.com>
 <1434447031-21434-3-git-send-email-prladdha@cisco.com>
 <5583B18C.7020303@xs4all.nl>
In-Reply-To: <5583B18C.7020303@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1AB8227C7ADD84A8FDCE1BCA6BB4449@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your comments Hans.

On 19/06/15 11:37 am, "Hans Verkuil" <hverkuil@xs4all.nl> wrote:

>>  utils/v4l2-ctl/v4l2-ctl-stds.cpp | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>> 
>> diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
>>b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
>> index c0e919b..9734c80 100644
>> --- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
>> +++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
>> @@ -41,7 +41,10 @@ void stds_usage(void)
>>  	       "                     index=<index>: use the index as provided
>>by --list-dv-timings\n"
>>  	       "                     or specify timings using cvt/gtf options
>>as follows:\n"
>>  	       "      
>>cvt/gtf,width=<width>,height=<height>,fps=<frames per sec>\n"
>> -	       "      
>>interlaced=<0/1>,reduced-blanking=<0/1>\n"
>> +	       "      
>>interlaced=<0/1>,reduced-blanking=<0/1>,use-rb-v2=<0/1>\n"
>> +	       "                     use-rb-v2 indicates whether to use
>>reduced blanking version 2\n"
>> +	       "                     or not. This flag is relevant only for
>>cvt timings and has\n"
>> +	       "                     effect only if reduced-blanking=1\n"
>
>Why not just allow a value of 2 for the reduced-blanking argument instead
>of introducing a new argument? For gtf 1 and 2 mean the same thing, for
>cvt 1
>will use the standard RB and 2 RBv2.

The only reason for which I added another flag is to make control
parameters same as cvt spreadsheet. But, yes, we could accept
reduced-blanking = 2. I will post version 2 with this change.

>
>Seems simpler to me. It also means that calc_cvt_modeline doesn't need a
>new
>argument, just that bool reduced_blanking becomes int reduced_blanking.
>
>Other than this it looks good to me.
>
>Regards,
>
>	Hans
>
>>  	       "                     or give a fully specified timings:\n"
>>  	       "      
>>width=<width>,height=<height>,interlaced=<0/1>,\n"
>>  	       "                     polarities=<polarities
>>mask>,pixelclock=<pixelclock Hz>,\n"
>> @@ -148,6 +151,7 @@ enum timing_opts {
>>  	GTF,
>>  	FPS,
>>  	REDUCED_BLANK,
>> +	USE_RB_V2,
>>  };
>>  
>>  static int parse_timing_subopt(char **subopt_str, int *value)
>> @@ -175,6 +179,7 @@ static int parse_timing_subopt(char **subopt_str,
>>int *value)
>>  		"gtf",
>>  		"fps",
>>  		"reduced-blanking",
>> +		"use-rb-v2",
>>  		NULL
>>  	};
>>  
>> @@ -205,6 +210,7 @@ static void get_cvt_gtf_timings(char *subopt, int
>>standard,
>>  	int fps = 0;
>>  	int r_blank = 0;
>>  	int interlaced = 0;
>> +	int use_rb_v2 = 0;
>>  
>>  	bool timings_valid = false;
>>  
>> @@ -231,6 +237,8 @@ static void get_cvt_gtf_timings(char *subopt, int
>>standard,
>>  		case INTERLACED:
>>  			interlaced = opt_val;
>>  			break;
>> +		case USE_RB_V2:
>> +			use_rb_v2 = opt_val;
>>  		default:
>>  			break;
>>  		}
>> @@ -240,7 +248,8 @@ static void get_cvt_gtf_timings(char *subopt, int
>>standard,
>>  		timings_valid = calc_cvt_modeline(width, height, fps,
>>  			              r_blank == 1 ? true : false,
>>  			              interlaced == 1 ? true : false,
>> -			              false, bt);
>> +			              use_rb_v2 == 1 ? true : false,
>> +			              bt);
>>  	} else {
>>  		timings_valid = calc_gtf_modeline(width, height, fps,
>>  			              r_blank == 1 ? true : false,
>> 
>

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
