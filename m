Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45489 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755261AbcIOGjV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 02:39:21 -0400
Subject: Re: [v4l-utils PATCH v1.2 2/2] media-ctl: Print information related
 to a single entity
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
References: <2226876.Vxqef30rz5@avalon>
 <1473863379-4875-1-git-send-email-sakari.ailus@linux.intel.com>
 <163775066.40INlWgSp9@avalon>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57DA4216.5000601@linux.intel.com>
Date: Thu, 15 Sep 2016 09:39:18 +0300
MIME-Version: 1.0
In-Reply-To: <163775066.40INlWgSp9@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/16 01:05, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Wednesday 14 Sep 2016 17:29:39 Sakari Ailus wrote:
>> Add a possibility to printing all information related to a given entity by
>> using both -p and -e options. This may be handy sometimes if only a single
>> entity is of interest and there are many entities.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>> Fixed the commit message as well.
>>
>>  utils/media-ctl/media-ctl.c | 33 +++++++++++++++------------------
>>  utils/media-ctl/options.c   |  2 ++
>>  2 files changed, 17 insertions(+), 18 deletions(-)
>>
>> diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
>> index 0499008..109cc11 100644
>> --- a/utils/media-ctl/media-ctl.c
>> +++ b/utils/media-ctl/media-ctl.c
>> @@ -504,19 +504,11 @@ static void media_print_topology_text(struct
>> media_device *media) media, media_get_entity(media, i));
>>  }
>>
>> -void media_print_topology(struct media_device *media, int dot)
>> -{
>> -	if (dot)
>> -		media_print_topology_dot(media);
>> -	else
>> -		media_print_topology_text(media);
>> -}
>> -
>>  int main(int argc, char **argv)
>>  {
>>  	struct media_device *media;
>> +	struct media_entity *entity = NULL;
>>  	int ret = -1;
>> -	const char *devname;
>>
>>  	if (parse_cmdline(argc, argv))
>>  		return EXIT_FAILURE;
>> @@ -562,17 +554,11 @@ int main(int argc, char **argv)
>>  	}
>>
>>  	if (media_opts.entity) {
>> -		struct media_entity *entity;
>> -
>>  		entity = media_get_entity_by_name(media, media_opts.entity);
>>  		if (entity == NULL) {
>>  			printf("Entity '%s' not found\n", media_opts.entity);
>>  			goto out;
>>  		}
>> -
>> -		devname = media_entity_get_devname(entity);
>> -		if (devname)
>> -			printf("%s\n", devname);
>>  	}
>>
>>  	if (media_opts.fmt_pad) {
>> @@ -611,9 +597,20 @@ int main(int argc, char **argv)
>>  		}
>>  	}
>>
>> -	if (media_opts.print || media_opts.print_dot) {
>> -		media_print_topology(media, media_opts.print_dot);
>> -		printf("\n");
>> +	if (media_opts.print_dot) {
>> +		media_print_topology_dot(media);
>> +	} else if (media_opts.print) {
>> +		if (entity) {
>> +			media_print_topology_text_entity(media, entity);
>> +		} else {
>> +			media_print_topology_text(media);
>> +		}
> 
> You could remove the curly braces here.

Will fix.

> 
>> +	} else if (entity) {
>> +		const char *devname;
>> +
>> +		devname = media_entity_get_devname(entity);
>> +		if (devname)
>> +			printf("%s\n", devname);
>>  	}
>>
>>  	if (media_opts.reset) {
>> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
>> index a288a1b..304a86c 100644
>> --- a/utils/media-ctl/options.c
>> +++ b/utils/media-ctl/options.c
>> @@ -52,6 +52,8 @@ static void usage(const char *argv0)
>>  	printf("-l, --links links	Comma-separated list of link 
> descriptors to
>> setup\n"); printf("    --known-mbus-fmts	List known media bus formats 
> and
>> their numeric values\n"); printf("-p, --print-topology	Print the 
> device
>> topology\n");
>> +	printf("			If entity name is specified using -e 
> option, information\n");
>> +	printf("			related to that entity only is 
> printed.\n");
> 
> Nitpicking, was anything wrong with
> 
> printf("-p, --print-topology    Print the device topology. If an entity\n");
> printf("                        is specified through the -e option, print\n");
> printf("                        information for that entity only.\n);

Not necessarily, but I missed that part of your reply. I'll replace it.

> 
> ? I think the help text looks more natural when using articles :-)

The message was still clear, wasn't it? :-D

> 
>>  	printf("    --print-dot		Print the device topology as a dot 
> graph\n");
>>  	printf("-r, --reset		Reset all links to inactive\n");
>>  	printf("-v, --verbose		Be verbose\n");
> 


-- 
Cheers,

Sakari Ailus
sakari.ailus@linux.intel.com
