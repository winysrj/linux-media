Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bruce.schultz@gmail.com>) id 1JOXb1-0004fc-R5
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 13:17:16 +0100
Received: by py-out-1112.google.com with SMTP id a29so4887169pyi.0
	for <linux-dvb@linuxtv.org>; Mon, 11 Feb 2008 04:17:04 -0800 (PST)
Message-ID: <47B03CBA.3080302@gmail.com>
Date: Mon, 11 Feb 2008 22:16:58 +1000
From: Bruce Schultz <bruce.schultz@gmail.com>
MIME-Version: 1.0
To: "Peter D." <peter_s_d@fastmail.com.au>
References: <20080120194031.47ad683c@jeff.localdomain>	<200801202147.47979.peter_s_d@fastmail.com.au>	<4793534B.5050009@gmail.com>
	<200801210913.45283.peter_s_d@fastmail.com.au>
In-Reply-To: <200801210913.45283.peter_s_d@fastmail.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Update to au-Melbourne scan list
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1840693675=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1840693675==
Content-Type: multipart/alternative;
 boundary="------------040706000003040502010307"

This is a multi-part message in MIME format.
--------------040706000003040502010307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


On 21/01/08 08:13, Peter D. wrote:
> On Monday 21 January 2008, Bruce Schultz wrote:
>   
>> On 20/01/08 20:47, Peter D. wrote:
>>     
>>> On Sunday 20 January 2008, Jeff Bailes wrote:
>>>       
>>>> Hi,
>>>> 	Back in November, channel Seven changed their fec_hi from 2/3 to 3/4
>>>> causing scans to not pick it up
>>>> ( http://www.dba.org.au/index.asp?sectionID=39&newsID=982&display=news
>>>> ). The new entry in the au-Melbourne file for channel seven should be:
>>>> # Seven
>>>> T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>>
>>>> I attached the complete updated file anyway.
>>>> 	Jeff
>>>>         
>>> They are a pain.
>>>
>>> Anyway, according to the web site that you quoted, all tuners that
>>> comply with Australian standards will cope without adjustment. 
>>> Unfortunately not all tuners comply with Australian standards.  :-(
>>>
>>> Presumably all au-tuning_files should have their channel 7 entry
>>> updated. Can this be done at the data base end, or do all files have to
>>> be re-submitted?  Also the GI in Brisbane is noted as changing as well.
>>>       
>> I can confirm that the au-Brisbane scan file needs to change. It works
>> now for me with the same channel 7 line that Jeff included above. Scan
>> wasn't finding channel 7 without the change.
>>     
>
> Did you just change fec_hi, or did you change the Guard Interval as 
> well?  The quoted web page states that the GI is now 1/16.  (It is 
> possible that your card is smart enough to sort out GI by itself, 
> but not fec_hi.)  
>   
Sorry about the belated reply.... Yes, I changed the GI to 1/16.



--------------040706000003040502010307
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
On 21/01/08 08:13, Peter D. wrote:
<blockquote cite="mid:200801210913.45283.peter_s_d@fastmail.com.au"
 type="cite">
  <pre wrap="">On Monday 21 January 2008, Bruce Schultz wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">On 20/01/08 20:47, Peter D. wrote:
    </pre>
    <blockquote type="cite">
      <pre wrap="">On Sunday 20 January 2008, Jeff Bailes wrote:
      </pre>
      <blockquote type="cite">
        <pre wrap="">Hi,
	Back in November, channel Seven changed their fec_hi from 2/3 to 3/4
causing scans to not pick it up
( <a class="moz-txt-link-freetext" href="http://www.dba.org.au/index.asp?sectionID=39&newsID=982&display=news">http://www.dba.org.au/index.asp?sectionID=39&amp;newsID=982&amp;display=news</a>
). The new entry in the au-Melbourne file for channel seven should be:
# Seven
T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE

I attached the complete updated file anyway.
	Jeff
        </pre>
      </blockquote>
      <pre wrap="">They are a pain.

Anyway, according to the web site that you quoted, all tuners that
comply with Australian standards will cope without adjustment. 
Unfortunately not all tuners comply with Australian standards.  :-(

Presumably all au-tuning_files should have their channel 7 entry
updated. Can this be done at the data base end, or do all files have to
be re-submitted?  Also the GI in Brisbane is noted as changing as well.
      </pre>
    </blockquote>
    <pre wrap="">I can confirm that the au-Brisbane scan file needs to change. It works
now for me with the same channel 7 line that Jeff included above. Scan
wasn't finding channel 7 without the change.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Did you just change fec_hi, or did you change the Guard Interval as 
well?  The quoted web page states that the GI is now 1/16.  (It is 
possible that your card is smart enough to sort out GI by itself, 
but not fec_hi.)  
  </pre>
</blockquote>
Sorry about the belated reply.... Yes, I changed the GI to 1/16.<br>
<br>
<br>
</body>
</html>

--------------040706000003040502010307--


--===============1840693675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1840693675==--
