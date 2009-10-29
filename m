Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbZJ2PUH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 11:20:07 -0400
Date: Thu, 29 Oct 2009 16:19:49 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net,
	eric.dumazet@gmail.com, jeffrey.t.kirsher@intel.com,
	jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
	peter.p.waskiewicz.jr@intel.com, john.ronciak@intel.com,
	e1000-devel@lists.sourceforge.net, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH net-next-2.6 1/4] net: introduce mc list helpers
Message-ID: <20091029151949.GH2877@psychotron.lab.eng.brq.redhat.com>
References: <20091022135120.GC2868@psychotron.lab.eng.brq.redhat.com> <20091022135220.GD2868@psychotron.lab.eng.brq.redhat.com> <1256221112.2785.13.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1256221112.2785.13.camel@achroite>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thu, Oct 22, 2009 at 04:18:32PM CEST, bhutchings@solarflare.com wrote:
>On Thu, 2009-10-22 at 15:52 +0200, Jiri Pirko wrote:
>> This helpers should be used by network drivers to access to netdev
>> multicast lists.
>[...]
>> +static inline void netdev_mc_walk(struct net_device *dev,
>> +				  void (*func)(void *, unsigned char *),
>> +				  void *data)
>> +{
>> +	struct dev_addr_list *mclist;
>> +	int i;
>> +
>> +	for (i = 0, mclist = dev->mc_list; mclist && i < dev->mc_count;
>> +	     i++, mclist = mclist->next)
>> +		func(data, mclist->dmi_addr);
>> +}
>[...]
>
>﻿We usually implement iteration as macros so that any context doesn't
>have to be squeezed through a single untyped (void *) variable.  A macro
>for this would look something like:
>
>#define netdev_for_each_mc_addr(dev, addr)						\
>	for (addr = (dev)->mc_list ? (dev)->mc_list->dmi_addr : NULL;			\
>	     addr;									\
>	     addr = (container_of(addr, struct dev_addr_list, dmi_addr)->next ?		\
>		     ﻿container_of(addr, struct dev_addr_list, dmi_addr)->next->dmi_addr : \
>		     NULL))
>
>Once you change the list type this can presumably be made less ugly.

Looking at this, I'm not sure how to deal with this macro once we need to
convert it to work with list_head. I see two options:

1) traverse through the list by hand in this macro (ugly)
2) introduce something like "list_for_each_struct_entry" which takes pointer of
   the structure member as a cursor. Then netdev_for_each_mc_addr would be just
   wrap-up of this.

What do you think?

Thanks

Jirka
>
>Ben.
>
>-- 
>Ben Hutchings, Senior Software Engineer, Solarflare Communications
>Not speaking for my employer; that's the marketing department's job.
>They asked us to note that Solarflare product names are trademarked.
>
