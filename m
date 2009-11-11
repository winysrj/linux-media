Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63300 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023AbZKKVLa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 16:11:30 -0500
Message-ID: <4AFB2878.8050001@maxwell.research.nokia.com>
Date: Wed, 11 Nov 2009 23:11:20 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4?=
	 =?ISO-8859-1?Q?_Antti_Jussi_Petteri?= <antti.koskipaa@nokia.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	"talvala@stanford.edu" <talvala@stanford.edu>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Stan Varbanov <svarbanov@mm-sol.com>,
	Valeri Ivanov <vivanov@mm-sol.com>,
	Atanas Filipov <afilipov@mm-sol.com>
Subject: Re: OMAP 3 ISP and N900 sensor driver update
References: <4AF41BDE.4040908@maxwell.research.nokia.com> <A69FA2915331DC488A831521EAE36FE401558AB44B@dlee06.ent.ti.com> <200911091506.27980.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E73940436F94663@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436F94663@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hiremath, Vaibhav wrote:
>> As far as I know nobody on our side is currently working on the CCDC
>> driver.
>> We're focusing on the previewer and resizer first.
>>
> [Hiremath, Vaibhav] I believe I should be able to see the current development activity on sakari's repo, right?

That's right. Just use the cont branch if you want to pull. Then the log 
will be garbage. The alternative is to use the devel branch but then you 
cannot pull, instead use fetch always and manually reapply local 
changes. Pick your poison. :-)

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
