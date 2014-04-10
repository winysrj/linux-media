Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43233 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934889AbaDJSxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 14:53:09 -0400
Message-ID: <5346E893.6060402@iki.fi>
Date: Thu, 10 Apr 2014 21:53:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 6/9] Timestamp source for output buffers
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <1393690690-5004-7-git-send-email-sakari.ailus@iki.fi> <24499912.nkDMIsTe95@avalon>
In-Reply-To: <24499912.nkDMIsTe95@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
...
>> @@ -1298,7 +1302,8 @@ static struct option opts[] = {
>>   	{"sleep-forever", 0, 0, OPT_SLEEP_FOREVER},
>>   	{"stride", 1, 0, OPT_STRIDE},
>>   	{"time-per-frame", 1, 0, 't'},
>> -	{"userptr", 0, 0, 'u'},
>> +	{"timestamp-source", 1, 0, OPT_TSTAMP_SRC},
>> +	{"userptr", 1, 0, 'u'},
>
> This seems to be an unrelated change.

Oops! My bad.

>>   	{0, 0, 0, 0}
>>   };
>>
>> @@ -1487,6 +1492,17 @@ int main(int argc, char *argv[])
>>   		case OPT_STRIDE:
>>   			stride = atoi(optarg);
>>   			break;
>> +		case OPT_TSTAMP_SRC:
>> +			if (!strcmp(optarg, "eof")) {
>> +				dev.buffer_output_flags |= V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
>
> As the buffer_output_flags isn't used for anything else, would it make sense
> to just name it timestamp_source ?

Currently not. But it could. I'm fine with the change if you insist. :-)

>> +			} else if (!strcmp(optarg, "soe")) {
>> +				dev.buffer_output_flags |= V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
>> +			} else {
>> +				printf("Invalid timestamp source %s\n", optarg);
>> +				return 1;
>> +			}
>> +			printf("Using %s timestamp source\n", optarg);
>
> Do we really need this printf ?

Time to add a "verbose" option? :-D

I'll remove it.

-- 
Cheers,

Sakari Ailus
sakari.ailus@iki.fi
