Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2199 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaC1KuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 06:50:20 -0400
Message-ID: <533553E6.3060508@xs4all.nl>
Date: Fri, 28 Mar 2014 11:50:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-sparse@vger.kernel.org
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: sparse: ARRAY_SIZE and sparse array initialization
References: <532442E2.7050206@xs4all.nl> <532443AB.9080105@xs4all.nl>
In-Reply-To: <532443AB.9080105@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any chance that the three issues I reported will be fixed? If not,
then I'll work around it in the kernel code.

Regards,

	Hans

On 03/15/2014 01:12 PM, Hans Verkuil wrote:
> For the record: all these tests were done with a 3.14-rc5 kernel and sparse
> compiled from the git tree as of today (version v0.5.0). The gcc version is 4.8.2.
> 
> Regards,
> 
> 	Hans
> 
> On 03/15/2014 01:09 PM, Hans Verkuil wrote:
>> Hmm, interesting. Twice 'sparse' in the same subject line with different meanings :-)
>>
>> This is another sparse error I get with drivers/media/v4l2-core/v4l2-ioctl.c:
>>
>> drivers/media/v4l2-core/v4l2-ioctl.c:424:9: error: cannot size expression
>>
>> (there are more of those in drivers/media, all with the same cause).
>>
>> This sparse (the tool) error occurs because of sparse (C language) array initialization
>> in combination with ARRAY_SIZE:
>>
>> static const char *v4l2_memory_names[] = {
>>         [V4L2_MEMORY_MMAP]    = "mmap",
>>         [V4L2_MEMORY_USERPTR] = "userptr",
>>         [V4L2_MEMORY_OVERLAY] = "overlay",
>>         [V4L2_MEMORY_DMABUF] = "dmabuf",
>> };
>>
>> #define prt_names(a, arr) (((unsigned)(a)) < ARRAY_SIZE(arr) ? arr[a] : "unknown")
>>
>> static void v4l_print_requestbuffers(const void *arg, bool write_only)
>> {
>>         const struct v4l2_requestbuffers *p = arg;
>>
>>         pr_cont("count=%d, type=%s, memory=%s\n",
>>                 p->count,
>>                 prt_names(p->type, v4l2_type_names),
>>                 prt_names(p->memory, v4l2_memory_names));
>> }
>>
>> I could change v4l2_memory_names to:
>>
>> static const char *v4l2_memory_names[V4L2_MEMORY_DMABUF + 1] = {
>>
>> and the error goes away.
>>
>> I'm actually not sure if this is a sparse bug or a feature.
>>
>> If it is a feature then the error message is definitely wrong, since the size is
>> perfectly well defined. As an aside: the error message is pretty vague IMHO.
>>
>> Regards,
>>
>> 	Hans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

